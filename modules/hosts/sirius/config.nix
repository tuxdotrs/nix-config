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
        boot.secure-boot.enable = true;
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
      ];

      # !!! DO NOT CHANGE THIS !!!
      # This should match the version used at initial install.
      system.stateVersion = "26.05";
    };
}
