{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.mpv = {
        enable = true;

        scripts = (
          with pkgs.mpvScripts;
          [
            modernz
            thumbfast
            mpris
            mpv-image-viewer.image-positioning
          ]
        );

        config = {
          osc = "no";
          border = "no";
        };
      };
    };
}
