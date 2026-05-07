{ config, ... }:
{
  flake.modules.nixos.sirius =
    {
      pkgs,
      hostName,
      ...
    }:
    {

      imports = with config.flake.modules.nixos; [
        networking
        desktop
        virtualisation
      ];

      tnix = {
        services.openssh.enable = true;

        virtualisation = {
          docker.enable = true;
          docker.nvidia.enable = true;
          qemu.enable = true;
          waydroid.enable = true;
        };
      };

      sops.secrets.tux-password = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      };

      # --- Boot ---
      boot = {
        loader = {
          systemd-boot.enable = true;
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
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
        };

        enableAllFirmware = true;
        usb-modeswitch.enable = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      # --- Programs ---
      programs.firefox.enable = true;

      # !!! DO NOT CHANGE THIS !!!
      # This should match the version used at initial install.
      system.stateVersion = "26.05";
    };
}
