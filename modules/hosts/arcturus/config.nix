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
        hardware
        networking
        virtualisation
        services
      ];

      tnix = {
        boot.secure-boot.enable = true;
        boot.impermanence.enable = true;
        networking.openssh.enable = true;

        services = {
          cyber-tux = {
            enable = true;
            environmentFile = innerArgs.config.sops.secrets.discord-token.path;
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
        nvtopPackages.full
      ];

      system.stateVersion = "26.05";
    };
}
