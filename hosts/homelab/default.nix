{
  inputs,
  username,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.default

    (import ./disko.nix {device = "/dev/nvme0n1";})
    ./hardware.nix

    ../common
    ../../modules/nixos/desktop
    ../../modules/nixos/virtualisation/docker.nix
    ../../modules/nixos/selfhosted/open-webui.nix
  ];

  tux.services.openssh.enable = true;

  sops.secrets = {
    discord_token = {
      sopsFile = ./secrets.yaml;
    };
  };

  tux.services.cyber-tux = {
    enable = true;
    environmentFile = config.sops.secrets.discord_token.path;
  };

  networking = {
    hostName = "homelab";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [22];

      # Facilitate firewall punching
      allowedUDPPorts = [41641];
    };
  };

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelPackages = pkgs.linuxPackages_zen;

    initrd.systemd = {
      enable = lib.mkForce true;

      services.wipe-my-fs = {
        wantedBy = ["initrd.target"];
        after = ["initrd-root-device.target"];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir /btrfs_tmp
          mount /dev/disk/by-partlabel/disk-primary-root /btrfs_tmp

          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  hardware = {
    graphics.enable32Bit = true;
  };

  security = {
    rtkit.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
  };

  services = {
    tailscale = {
      enable = true;
      extraUpFlags = ["--login-server https://hs.tux.rs"];
    };
  };

  programs.fuse.userAllowOther = true;
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/tailscale"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "24.11";
}
