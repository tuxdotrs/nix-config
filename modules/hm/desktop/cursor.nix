{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 28;
      };
    };
}
