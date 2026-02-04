{pkgs, ...}: {
  programs.satty = {
    enable = true;
    settings = {
      general = {
        corner-roundness = 12;
        initial-tool = "arrow";
        early-exit = true;
        copy-command = "wl-copy";
      };

      font = {
        family = "JetBrainsMono NerdFont";
      };
    };
  };

  home.packages = with pkgs; [
    grim
    slurp
    hyprshot
    wl-clipboard
    wl-screenrec
    (writeShellScriptBin "hypr-screenshot" ''
      hyprshot -m region -r ppm - | satty --filename -
    '')

    (writeShellScriptBin "hypr-screenrecord" ''
      wl-screenrec -g "$(slurp)"
    '')
  ];
}
