{pkgs, ...}: {
  services = {
    displayManager = {
      defaultSession = "none+awesome";
      ly = {
        enable = true;
        settings = {
          session_log = "null";
        };
      };
    };

    acpid.enable = true;
    picom.enable = true;
    upower.enable = true;
    blueman.enable = true;
  };

  programs.dconf.enable = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["brave-browser.desktop"];
      "text/html" = ["brave-browser.desktop"];
      "x-scheme-handler/http" = ["brave-browser.desktop"];
      "x-scheme-handler/https" = ["brave-browser.desktop"];
      "x-scheme-handler/about" = ["brave-browser.desktop"];
      "x-scheme-handler/unknown" = ["brave-browser.desktop"];
    };
  };

  environment.systemPackages = with pkgs; [
    acpi
    linuxKernel.packages.linux_zen.acpi_call
    inotify-tools
    polkit_gnome
    xdotool
    xclip
    xbacklight
    gpick
    alsa-utils
    pavucontrol
    brightnessctl
    libnotify
    feh
    maim
    mpdris2
    xdg-utils
    playerctl
    pulsemixer
    easyeffects
    procps
  ];
}
