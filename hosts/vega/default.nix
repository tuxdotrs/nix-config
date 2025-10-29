{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
    ../common

    ../../modules/nixos/selfhosted/adguard.nix
  ];

  tux.services.openssh.enable = true;

  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
    "vc4"
    "pcie_brcmstb" # required for the pcie bus to work
    "reset-raspberrypi" # required for vl805 firmware to load
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  networking = {
    hostName = "vega";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [22];

      # Facilitate firewall punching
      allowedUDPPorts = [41641];
    };
  };

  services = {
    tailscale = {
      enable = true;
      extraUpFlags = ["--login-server https://hs.tux.rs"];
    };
  };

  environment.systemPackages = with pkgs; [go-wol];

  environment.persistence."/persist" = {
    enable = false;
  };

  users.users.${username} = {linger = true;};
  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "24.11";
}
