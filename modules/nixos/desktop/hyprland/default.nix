{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland-git.hyprland;
    portalPackage = pkgs.hyprland-git.xdg-desktop-portal-hyprland;
  };
}
