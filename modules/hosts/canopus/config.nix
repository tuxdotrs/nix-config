{config, ...}: {
  flake.modules.nixos.canopus = {
    pkgs,
    hostName,
    userName,
    ...
  } @ innerArgs: {
    imports = with config.flake.modules.nixos; [
      boot
      networking
      desktop
      gaming
      virtualisation
      monitoring
    ];

    tnix = {
      boot = {
        secure-boot.enable = true;

        impermanence = {
          enable = true;

          directories = ["/etc/mullvad-vpn"];

          home = {
            directories = [
              "Distrobox"
              ".steam"
              ".bun"
              ".rustup"
              ".cache/awww"
              ".cache/serpantinum"
              ".cache/vicinae"
              ".config/BraveSoftware"
              ".config/zed"
              ".config/Vencord"
              ".config/vesktop"
              ".config/discord"
              ".config/sops"
              ".config/nix"
              ".config/coderv2"
              ".config/obs-studio"
              ".config/easyeffects"
              ".config/DankMaterialShell"
              ".config/Mullvad\ VPN"
              ".local/share/Steam"
              ".local/share/lutris"
              ".local/share/net.lutris.Lutris"
              ".local/share/nvim"
              ".local/share/opencode"
              ".local/share/zsh"
              ".local/share/zoxide"
              ".local/share/voxtype"
              ".local/share/vicinae"
              ".local/state/vicinae"
              ".local/state/lazygit"
              ".local/share/TelegramDesktop"
              ".local/share/GalaxyBudsClient"
              ".local/state/serpantinum"
              ".local/share/zed"

              ".agents"
              ".claude"
              ".orca"
              ".config/orca"
              ".zcode"
              ".config/ZCode"
              ".pi/agent/sessions"
              ".omp"
            ];

            files = [
              ".wakatime.cfg"
              ".claude.json"
              ".config/gh/hosts.yml"
            ];
          };
        };
      };

      networking = {
        openssh.enable = true;
        netbird-client.enable = true;
        mullvad-vpn.enable = true;
      };

      virtualisation = {
        docker.enable = true;
        docker.nvidia.enable = false;
        qemu.enable = true;
        waydroid.enable = true;
        distrobox.enable = true;
      };

      monitoring.alloy = {
        enable = true;
        environmentFile = innerArgs.config.sops.secrets.alloy.path;
      };

      programs.nix-ld.enable = true;
    };

    sops.secrets = {
      tux-password = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      };

      gemini-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      openrouter-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      opencode-go-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      zai-coding-plan-api-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      netbird-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      vicinae-json = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      alloy = {
        sopsFile = ./secrets.yaml;
      };
    };

    # --- Networking ---
    networking = {
      hostName = hostName;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
        wifi.powersave = false;
      };
      wireless.iwd = {
        enable = true;
        settings = {
          Network = {
            EnableIPv6 = true;
          };
          Settings = {
            AutoConnect = true;
          };
        };
      };
      firewall.enable = false;
    };

    environment.systemPackages = with pkgs; [
      davinci-resolve
      telegram-desktop
      galaxy-buds-client
      impala
      llm-agents.claude-code
      llm-agents.orca
      llm-agents.zcode
      coder
    ];

    # !!! DO NOT CHANGE THIS !!!
    # This should match the version used at initial install.
    system.stateVersion = "26.05";
  };
}
