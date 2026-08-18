{ config, ... }:
{
  flake.modules.nixos.arcturus =
    {
      pkgs,
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
          hermes-agent = {
            enable = true;
            environmentFiles = [ innerArgs.config.sops.secrets.hermes.path ];
          };

          cyber-tux = {
            enable = true;
            environmentFile = innerArgs.config.sops.secrets.discord-token.path;
          };

          vaultwarden = {
            enable = true;
            domain = "bw.lab.tux.rs";
            configurePangolin = true;
          };

          copyparty = {
            enable = true;
            domain = "files.lab.tux.rs";
            accounts.${userName}.passwordFile = innerArgs.config.sops.secrets.copyparty.path;
            volumes = {
              "/" = {
                path = "/var/lib/copyparty/data";
                access = {
                  r = "*";
                  rwmdgGha = [ userName ];
                };
              };
            };
            configurePangolin = true;
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

        copyparty = {
          sopsFile = ./secrets.yaml;
          owner = innerArgs.config.services.copyparty.user;
        };

        hermes = {
          sopsFile = ./secrets.yaml;
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

      environment.systemPackages = with pkgs; [
        impala
      ];

      system.stateVersion = "26.05";
    };
}
