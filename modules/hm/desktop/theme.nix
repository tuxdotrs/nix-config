{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 28;
      };

      qt = {
        enable = true;
        style.name = "adwaita-dark";
      };

      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-black";
        };
      };

      # Make GTK4/libadwaita apps prefer dark too (they ignore gtk.theme).
      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
}
