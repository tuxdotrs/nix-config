{ config, ... }:
{
  flake.modules.nixos.sirius =
    {
      lib,
      pkgs,
      system,
      ...
    }@innerArgs:
    {
      imports = with config.flake.modules.nixos; [
        hardware
      ];

      boot.kernelParams = [ "nvidia-drm.modeset=1" ];
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      hardware = {
        nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
        };

        cpu.amd.updateMicrocode = lib.mkDefault innerArgs.config.hardware.enableRedistributableFirmware;
      };
      services.xserver.videoDrivers = [ "nvidia" ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.config.cudaSupport = true;
      nixpkgs.hostPlatform = lib.mkDefault system;

      environment.systemPackages = with pkgs; [
        nvtopPackages.full
      ];
    };
}
