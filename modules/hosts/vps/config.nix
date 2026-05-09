{ config, ... }:
{
  flake.modules.nixos.vps =
    {
      hostName,
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
              ];
            };
          };
        };

        networking.openssh.enable = true;

        virtualisation = {
          docker.enable = true;
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
