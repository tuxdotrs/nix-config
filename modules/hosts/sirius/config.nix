{ config, ... }:
{
  flake.modules.nixos.sirius =
    {
      pkgs,
      hostName,
      userName,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        boot
        hardware
        networking
        desktop
        virtualisation
      ];

      tnix = {
        boot = {
          secure-boot.enable = true;

          impermanence = {
            enable = true;

            home = {
              directories = [
                ".cache/awww"
                ".config/BraveSoftware"
                ".config/zed"
                ".config/Vencord"
                ".config/vesktop"
                ".config/sops"
                ".config/obs-studio"
                ".config/easyeffects"
                ".config/DankMaterialShell"
                ".local/share/nvim"
                ".local/share/opencode"
                ".local/share/zsh"
                ".local/share/zoxide"
                ".local/state/lazygit"
                ".local/share/vicinae"
                ".local/share/TelegramDesktop"
              ];

              files = [
                ".wakatime.cfg"
                ".config/lan-mouse/lan-mouse.pem"
              ];
            };
          };
        };

        networking.openssh.enable = true;

        virtualisation = {
          docker.enable = true;
          docker.nvidia.enable = true;
          qemu.enable = true;
          waydroid.enable = true;
          distrobox.enable = true;
        };
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

        vicinae-json = {
          sopsFile = ./secrets.yaml;
          owner = userName;
        };
      };

      # --- Networking ---
      networking = {
        hostName = hostName;
        networkmanager = {
          enable = true;
          wifi.backend = "iwd";
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

      # --- Hardware / GPU ---
      hardware = {
        nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
        };
      };
      boot.kernelParams = [ "nvidia-drm.modeset=1" ];
      nixpkgs.config.cudaSupport = true;
      services.xserver.videoDrivers = [ "nvidia" ];

      environment.systemPackages = with pkgs; [
        nvtopPackages.full
        davinci-resolve
        telegram-desktop
      ];

      # !!! DO NOT CHANGE THIS !!!
      # This should match the version used at initial install.
      system.stateVersion = "26.05";
    };
}
