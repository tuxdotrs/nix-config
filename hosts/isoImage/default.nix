{
  pkgs,
  modulesPath,
  inputs,
  username,
  lib,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.home-manager.nixosModules.home-manager

    ../common
    ../../modules/nixos/desktop
    ../../modules/nixos/desktop/awesome
    ../../modules/nixos/desktop/hyprland
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking = {
    hostName = "iso";
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  security = {
    rtkit.enable = true;
  };

  programs = {
    ssh.startAgent = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
    nm-applet.enable = true;
  };

  services = {
    resolved.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    logind = {
      extraConfig = "HandlePowerKey=suspend";
      lidSwitch = "suspend";
      lidSwitchExternalPower = "suspend";
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "in";
        variant = "eng";
      };
    };

    libinput.touchpad.naturalScrolling = true;

    blueman.enable = true;

    gvfs.enable = true;
    tumbler.enable = true;
  };

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
  ];

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  users.users.${username} = {
    hashedPasswordFile = lib.mkForce null;
    initialPassword = username;
  };

  system.stateVersion = "23.11";
}
