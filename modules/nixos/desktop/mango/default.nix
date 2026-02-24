{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.mango.nixosModules.mango
  ];

  programs.mango.enable = true;

  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = with pkgs; [
      hyprland-git.xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.mango = {
      default = lib.mkForce ["hyprland" "gtk"];
      "org.freedesktop.impl.portal.ScreenCast" = lib.mkForce ["hyprland"];
      "org.freedesktop.impl.portal.ScreenShot" = lib.mkForce ["hyprland"];
    };
  };
}
