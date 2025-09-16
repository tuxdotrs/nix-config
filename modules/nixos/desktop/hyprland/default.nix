{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland-git.hyprland;
    portalPackage = pkgs.hyprland-git.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "mirror-display" ''
      hyprctl keyword monitor "HDMI-A-1,preferred,0x0,1,mirror,eDP-1" \
        && astal -q \
        && ${pkgs.tpanel}/bin/tpanel &
    '')
    (pkgs.writeShellScriptBin "extend-display" ''
      hyprctl keyword monitor "HDMI-A-1,preferred,0x-1440,1" \
        && astal -q \
        && ${pkgs.tpanel}/bin/tpanel &
    '')
  ];
}
