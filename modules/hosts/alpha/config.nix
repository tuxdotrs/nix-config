{ config, ... }:
{
  flake.modules.nixos.alpha =
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
          legacy.enable = true;

          impermanence = {
            enable = true;

            home = {
              directories = [
                ".local/share/nvim"
                ".local/share/zsh"
                ".local/share/zoxide"
                ".local/state/lazygit"
                ".local/share/opencode"
              ];
            };
          };
        };

        networking = {
          openssh.enable = true;
          netbird-client.enable = true;
        };

        services = {
          nginx = {
            enable = true;
            domain = "lab.tux.rs";
          };

          mediaflow-proxy = {
            enable = true;
            port = 8888;

            environment = {
              APP__SERVER__HOST = "0.0.0.0";
              APP__SERVER__PORT = "8888";
            };

            environmentFile = innerArgs.config.sops.secrets."mediaflow-proxy".path;
          };
        };

        virtualisation = {
          docker.enable = true;
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

        netbird-key = {
          sopsFile = ./secrets.yaml;
          owner = userName;
        };

        "cloudflare-credentials/email" = {
          sopsFile = ./secrets.yaml;
        };

        "cloudflare-credentials/dns-api-token" = {
          sopsFile = ./secrets.yaml;
        };

        aiostreams = {
          sopsFile = ./secrets.yaml;
        };

        mediaflow-proxy = {
          sopsFile = ./secrets.yaml;
        };
      };

      # --- Networking ---
      networking = {
        hostName = hostName;
        networkmanager.enable = true;
        firewall.enable = false;
      };

      system.stateVersion = "26.05";
    };
}
