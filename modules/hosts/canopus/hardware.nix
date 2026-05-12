{ config, ... }:
{
  flake.modules.nixos.canopus =
    {
      lib,
      system,
      ...
    }@innerArgs:
    {
      imports = with config.flake.modules.nixos; [
        hardware
      ];

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

      hardware.cpu.amd.updateMicrocode = lib.mkDefault innerArgs.config.hardware.enableRedistributableFirmware;

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault system;
    };
}
