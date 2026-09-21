{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.tnix.services.lan-mouse;
  in {
    imports = [inputs.lan-mouse.homeManagerModules.default];

    options.tnix.services.lan-mouse = {
      enable = lib.mkEnableOption "Enable Lan-Mouse";

      settings = lib.mkOption {
        type = (pkgs.formats.toml {}).type;
        default = {};
        description = ''
          TOML configuration for lan-mouse.
          See <https://github.com/feschber/lan-mouse/> for available options.
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      programs.lan-mouse = {
        enable = true;
        systemd = true;
        settings = cfg.settings;
      };
    };
  };
}
