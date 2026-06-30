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

                "/var/lib/docker"
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
          aiostreams = {
            enable = true;
            port = 4567;

            environment = {
              ADDON_ID = "aiostreams.lab.tux.rs";
              BASE_URL = "https://aiostreams.lab.tux.rs";
            };

            environmentFile = innerArgs.config.sops.secrets."aiostreams".path;
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
