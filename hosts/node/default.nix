{
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.default

    (import ./disko.nix {
      device = "/dev/nvme0n1";
      device2 = "/dev/nvme1n1";
      device3 = "/dev/sda";
    })
    ./hardware.nix

    ../common
  ];

  tux.services.openssh.enable = true;

  boot.loader.grub.enable = true;

  networking = {
    hostName = "node";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
    };
  };

  security.rtkit.enable = true;

  environment.persistence."/persist" = {
    enable = false;
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "25.05";
}
