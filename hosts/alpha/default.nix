{
  modulesPath,
  inputs,
  username,
  lib,
  email,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.default
    (import ./disko.nix {device = "/dev/vda";})

    ../common
    ../../modules/nixos/selfhosted/uptime-kuma.nix
  ];

  tux.services.openssh.enable = true;
  tux.services.openssh.ports = [23];

  tux.services.tfolio.enable = true;

  tux.services.nginxStreamProxy = {
    enable = true;
    upstreamServers = inputs.nix-secrets.proxy-servers;
  };

  sops.secrets = {
    borg_encryption_key = {
      sopsFile = ./secrets.yaml;
    };

    "cloudflare_credentials/email" = {
      sopsFile = ./secrets.yaml;
    };

    "cloudflare_credentials/dns_api_token" = {
      sopsFile = ./secrets.yaml;
    };
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  boot = {
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
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };

  networking = {
    hostName = "alpha";

    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 22 23];
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "${email}";
      certs = {
        "tux.rs" = {
          group = "nginx";
          domain = "*.tux.rs";
          extraDomainNames = ["tux.rs"];
          dnsProvider = "cloudflare";
          credentialFiles = {
            CLOUDFLARE_EMAIL_FILE = config.sops.secrets."cloudflare_credentials/email".path;
            CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare_credentials/dns_api_token".path;
          };
        };
      };
    };
  };

  users.users.nginx.extraGroups = ["acme"];

  services = {
    nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  programs.fuse.userAllowOther = true;
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/acme"
      "/var/lib/nixos"
      "/var/lib/private"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  users.users.${username} = {linger = true;};
  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "24.11";
}
