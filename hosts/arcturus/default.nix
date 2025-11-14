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
    ../../modules/nixos/virtualisation/docker.nix
    ../../modules/nixos/selfhosted/postgresql.nix
    ../../modules/nixos/selfhosted/headscale.nix
    ../../modules/nixos/selfhosted/vaultwarden.nix
    ../../modules/nixos/selfhosted/gitea.nix
    ../../modules/nixos/selfhosted/umami.nix
    ../../modules/nixos/selfhosted/monitoring/grafana.nix
    ../../modules/nixos/selfhosted/monitoring/loki.nix
    ../../modules/nixos/selfhosted/monitoring/promtail.nix
    ../../modules/nixos/selfhosted/ntfy-sh.nix
    ../../modules/nixos/selfhosted/searx.nix
    ../../modules/nixos/selfhosted/wakapi.nix
    ../../modules/nixos/selfhosted/nextcloud.nix
    ../../modules/nixos/selfhosted/silver-bullet.nix
    ../../modules/nixos/selfhosted/rustdesk-server.nix
    ../../modules/nixos/selfhosted/kasmweb.nix
    ../../modules/nixos/selfhosted/open-webui.nix
    ../../modules/nixos/selfhosted/glance
  ];

  tux.services.openssh.enable = true;
  tux.containers.aiostreams = {
    enable = true;
    port = 4567;
    environment = {
      ADDON_ID = "aiostreams.tux.rs";
      BASE_URL = "https://aiostreams.tux.rs";
    };

    environmentFiles = [
      config.sops.secrets."aiostreams".path
    ];
  };

  sops.secrets = {
    borg_encryption_key = {
      sopsFile = ./secrets.yaml;
    };

    searx_secret_key = {
      sopsFile = ./secrets.yaml;
    };

    "cloudflare_credentials/email" = {
      sopsFile = ./secrets.yaml;
    };

    "cloudflare_credentials/dns_api_token" = {
      sopsFile = ./secrets.yaml;
    };

    plausible_key = {
      sopsFile = ./secrets.yaml;
    };

    wakapi_salt = {
      sopsFile = ./secrets.yaml;
    };

    nextcloud_password = {
      sopsFile = ./secrets.yaml;
      owner = "nextcloud";
    };

    silver_bullet = {
      sopsFile = ./secrets.yaml;
    };

    "cs2_secrets/SRCDS_TOKEN" = {
      sopsFile = ./secrets.yaml;
    };

    "cs2_secrets/CS2_RCONPW" = {
      sopsFile = ./secrets.yaml;
    };

    "cs2_secrets/CS2_PW" = {
      sopsFile = ./secrets.yaml;
    };

    aiostreams = {
      sopsFile = ./secrets.yaml;
    };

    umami = {
      sopsFile = ./secrets.yaml;
    };
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

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
        configurationLimit = 10;
      };
      timeout = 1;
    };
  };

  networking = {
    hostName = "arcturus";

    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        22
        3333
        8081
      ];
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
      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
    };
  };

  programs.fuse.userAllowOther = true;
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/acme"
      "/var/lib/postgresql"
      "/var/lib/headscale"
      "/var/lib/vaultwarden"
      "/var/lib/gitea"
      "/var/lib/clickhouse"
      "/var/lib/grafana"
      "/var/lib/promtail"
      "/var/lib/private"
      "/var/lib/nextcloud"
      "/var/lib/silverbullet"
      "/var/lib/kasmweb"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  users.users.${username} = {
    linger = true;
  };
  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "24.11";
}
