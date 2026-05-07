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
        networking
        desktop
        virtualisation
      ];

      tnix = {
        boot.secure-boot.enable = true;
        services.openssh.enable = true;

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

        openrouter_api_key = {
          sopsFile = ./secrets.yaml;
          owner = userName;
        };

        opencode_go_api_key = {
          sopsFile = ./secrets.yaml;
          owner = userName;
        };

        "vicinae.json" = {
          sopsFile = ./secrets.yaml;
          owner = userName;
        };
      };

      # --- Boot ---
      boot = {
        loader = {
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "nvidia-drm.modeset=1" ];
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

      # --- Hardware / GPU ---
      hardware = {
        nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
        };
      };
      nixpkgs.config.cudaSupport = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      environment.systemPackages = with pkgs; [ nvtopPackages.full ];

      # !!! DO NOT CHANGE THIS !!!
      # This should match the version used at initial install.
      system.stateVersion = "26.05";
    };
}
