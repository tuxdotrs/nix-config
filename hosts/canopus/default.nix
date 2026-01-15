{
  inputs,
  username,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga503
    inputs.disko.nixosModules.default

    (import ./disko.nix {device = "/dev/nvme0n1";})
    ./hardware.nix

    ../common
    ../../modules/nixos/desktop
    ../../modules/nixos/desktop/awesome
    ../../modules/nixos/desktop/hyprland
    ../../modules/nixos/virtualisation
    ../../modules/nixos/steam.nix
  ];

  hardware.nvidia-container-toolkit.enable = true;
  tux.services.openssh.enable = true;
  tux.packages.distrobox.enable = true;
  nixpkgs.config.cudaSupport = true;

  sops.secrets = {
    hyperbolic_api_key = {
      sopsFile = ./secrets.yaml;
      owner = "${username}";
    };

    gemini_api_key = {
      sopsFile = ./secrets.yaml;
      owner = "${username}";
    };

    open_router_api_key = {
      sopsFile = ./secrets.yaml;
      owner = "${username}";
    };
  };

  networking = {
    hostName = "canopus";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        22
        3000
        6666
        8081
      ];

      # Facilitate firewall punching
      allowedUDPPorts = [41641 4242];

      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];

    plymouth = {
      enable = true;
      theme = "spinner-monochrome";
      themePackages = [
        (pkgs.plymouth-spinner-monochrome.override {inherit (config.boot.plymouth) logo;})
      ];
    };

    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = ["ntfs"];

    initrd = {
      kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      systemd = {
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
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics.enable32Bit = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    enableEmergencyMode = false;

    user = {
      services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };

  programs = {
    ssh.startAgent = true;
    xfconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
    };
    nm-applet.enable = true;
    noisetorch.enable = true;
  };

  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    resolved.enable = true;
    flatpak.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    logind = {
      settings.Login = {
        HandlePowerKey = "suspend";
        HanldeLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
      };
    };

    xrdp = {
      enable = true;
      openFirewall = true;
      defaultWindowManager = "awesome";
      audio.enable = true;
    };

    syncthing = {
      enable = true;
      user = "tux";
      dataDir = "/home/tux/";
      openDefaultPorts = true;
    };

    libinput.touchpad.naturalScrolling = true;
    libinput.mouse.accelProfile = "flat";

    # To use Auto-cpufreq we need to
    # disable TLP because it's enabled by nixos-hardware
    tlp.enable = false;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          platform_profile = "balanced";
          governor = "powersave";
          energy_performance_preference = "performance";
          turbo = "never";
          scaling_min_freq = 400000;
          scaling_max_freq = 3800000;
        };
        charger = {
          platform_profile = "performance";
          governor = "performance";
          energy_performance_preference = "performance";
          turbo = "auto";
          scaling_min_freq = 400000;
          scaling_max_freq = 3800000;
        };
      };
    };

    blueman.enable = true;

    supergfxd = {
      enable = true;
      settings = {
        mode = "Integrated";
        vfio_enable = false;
        vfio_save = false;
        always_reboot = false;
        no_logind = false;
        logout_timeout_s = 180;
        hotplug_type = "None";
      };
    };

    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig.text = ''
        (
          charge_control_end_threshold: 80,
          disable_nvidia_powerd_on_battery: true,
          ac_command: "",
          bat_command: "",

          platform_profile_linked_epp: true,
          platform_profile_on_battery: Quiet,
          platform_profile_on_ac: Performance,

          change_platform_profile_on_battery: true,
          change_platform_profile_on_ac: true,

          profile_quiet_epp: Power,
          profile_balanced_epp: BalancePower,
          profile_custom_epp: Performance,
          profile_performance_epp: Performance,

          ac_profile_tunings: {},
          dc_profile_tunings: {},
          armoury_settings: {},
        )
      '';
      profileConfig.text = ''
        (
          active_profile: Quiet,
        )
      '';
      fanCurvesConfig.text = ''
        (
          profiles: (
            balanced: [
              (
                fan: CPU,
                pwm: (2, 22, 45, 68, 91, 153, 153, 153),
                temp: (55, 62, 66, 70, 74, 78, 78, 78),
                enabled: false,
              ),
              (
                fan: GPU,
                pwm: (2, 25, 48, 71, 94, 165, 165, 165),
                temp: (55, 62, 66, 70, 74, 78, 78, 78),
                enabled: false,
              ),
            ],
            performance: [
              (
                fan: CPU,
                pwm: (35, 68, 79, 91, 114, 175, 175, 175),
                temp: (58, 62, 66, 70, 74, 78, 78, 78),
                enabled: false,
              ),
              (
                fan: GPU,
                pwm: (35, 71, 84, 94, 119, 188, 188, 188),
                temp: (58, 62, 66, 70, 74, 78, 78, 78),
                enabled: false,
              ),
            ],
            quiet: [
              (
                fan: CPU,
                pwm: (2, 12, 22, 35, 45, 58, 79, 79),
                temp: (55, 62, 66, 70, 74, 78, 82, 82),
                enabled: true,
              ),
              (
                fan: GPU,
                pwm: (2, 12, 25, 35, 48, 61, 84, 84),
                temp: (55, 62, 66, 70, 74, 78, 82, 82),
                enabled: true,
              ),
            ],
            custom: [],
          ),
        )
      '';
    };

    gvfs.enable = true;
    tumbler.enable = true;
    # @FIX gnome gcr agent conflicts with programs.ssh.startAgent;
    # gnome.gnome-keyring.enable = true;
    tailscale = {
      enable = true;
      extraUpFlags = ["--login-server https://hs.tux.rs"];
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
    bigblue-terminal
  ];

  programs.fuse.userAllowOther = true;
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/tailscale"
      "/var/lib/nixos"
      "/var/lib/docker"
      "/var/lib/waydroid"
      "/var/lib/iwd"
      "/var/lib/libvirt"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      # "/etc/machine-id"
      "/etc/ly/save.ini"
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
