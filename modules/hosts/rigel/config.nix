{config, ...}: {
  flake.modules.nixos.rigel = {
    hostName,
    userName,
    ...
  } @ innerArgs: {
    imports = with config.flake.modules.nixos; [
      boot
      networking
      virtualisation
      services
      monitoring
    ];

    tnix = {
      boot = {
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

      networking = {
        openssh.enable = true;
        netbird-client.enable = true;
      };

      services = {
        stalwart = {
          enable = true;
          openFirewall = true;
        };
      };

      virtualisation = {
        docker.enable = true;
      };

      monitoring = {
        alloy = {
          enable = true;
          environmentFile = innerArgs.config.sops.secrets.alloy.path;
        };
      };
    };

    sops.secrets = {
      tux-password = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      };

      netbird-key = {
        sopsFile = ./secrets.yaml;
        owner = userName;
      };

      alloy = {
        sopsFile = ./secrets.yaml;
      };
    };

    networking = {
      hostName = hostName;
      networkmanager.enable = true;
      firewall.enable = false;
    };

    system.stateVersion = "26.05";
  };
}
