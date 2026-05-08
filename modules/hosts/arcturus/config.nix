{ config, ... }:
{
  flake.modules.nixos.arcturus =
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
        virtualisation
      ];

      tnix = {
        boot.secure-boot.enable = true;
        boot.impermanence.enable = true;
        networking.openssh.enable = true;

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

      # --- Boot ---
      boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

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
