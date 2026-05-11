{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 28;
      };

      qt = {
        enable = true;
        style = {
          name = "Breeze";
          package = pkgs.kdePackages.breeze;
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Materia-dark";
          package = pkgs.materia-theme;
        };
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-black";
        };
      };
    };
}
