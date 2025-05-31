{
  lib,
  pkgs,
  ...
}: {
  services = {
    displayManager = {
      defaultSession = "none+awesome";
      ly.enable = true;
    };

    xserver = {
      enable = true;
      windowManager.awesome = {
        enable = true;
        luaModules = lib.attrValues {
          inherit
            (pkgs.luajitPackages)
            lgi
            ldbus
            luadbi-mysql
            luaposix
            dkjson
            ;
        };
      };
    };

    acpid.enable = true;
    picom.enable = true;
    upower.enable = true;
    blueman.enable = true;
  };

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    luajit
    acpi
    linuxKernel.packages.linux_zen.acpi_call
    lxappearance
    inotify-tools
    polkit_gnome
    xdotool
    xclip
    xorg.xbacklight
    gpick
    alsa-utils
    pavucontrol
    brightnessctl
    libnotify
    feh
    maim
    mpdris2
    python311Packages.mutagen
    xdg-utils
    playerctl
    pulsemixer
    easyeffects
    procps
    sct
    slop
    sddm-sugar-dark
  ];
}
