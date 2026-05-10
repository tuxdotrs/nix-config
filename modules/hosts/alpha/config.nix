{ config, ... }:
{
  flake.modules.nixos.alpha =
    {
      hostName,
      userName,
      modulesPath,
      ...
    }:
    {
      imports =
        with config.flake.modules.nixos;
        [
          boot
          hardware
          networking
          virtualisation
          services
        ]
        ++ [
          (modulesPath + "/profiles/qemu-guest.nix")
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
