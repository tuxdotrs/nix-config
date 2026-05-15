{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      services.gvfs.enable = true;

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };
}
