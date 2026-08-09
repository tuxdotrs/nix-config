{ config, ... }:
{
  flake.modules.nixos.arcturus =
    {
      hostName,
      userName,
      ...
    }@innerArgs:
    {
      imports = with config.flake.modules.nixos; [
        boot
        networking
        virtualisation
        services
      ];

      tnix = {
        boot = {
          secure-boot.enable = true;

          impermanence = {
            enable = true;

            home = {
              directories = [
                "Distrobox"
                ".config/sops"
                ".local/share/nvim"
                ".local/share/opencode"
                ".local/share/zsh"
                ".local/share/zoxide"
                ".local/state/lazygit"
              ];

              files = [
                ".wakatime.cfg"
              ];
            };
          };
        };

        networking = {
          openssh.enable = true;
          netbird-client.enable = true;
          newt = {
            enable = true;
            environmentFile = innerArgs.config.sops.secrets.newt.path;
          };
        };

        services = {
          cyber-tux = {
            enable = true;
            environmentFile = innerArgs.config.sops.secrets.discord-token.path;
          };

          vaultwarden = {
            enable = true;
            domain = "bw.lab.tux.rs";
          };
        };

        virtualisation = {
          docker.enable = true;
          distrobox.enable = true;
        };
      };

      sops.secrets = {
        tux-password = {
          sopsFile = ./secrets.yaml;
          neededForUsers = true;
        };

        discord-token = {
          sopsFile = ./secrets.yaml;
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

        netbird-key = {
          sopsFile = ./secrets.yaml;
          owner = userName;
        };

        newt = {
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

      system.stateVersion = "26.05";
    };
}
