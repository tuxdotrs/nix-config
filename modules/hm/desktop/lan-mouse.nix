{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.lan-mouse;
    in
    {
      imports = [ inputs.lan-mouse.homeManagerModules.default ];

      options.tnix.services.lan-mouse = {
        enable = mkEnableOption "Enable Lan-Mouse";

        settings = mkOption {
          type = (pkgs.formats.toml { }).type;
          default = { };
          description = ''
            TOML configuration for lan-mouse.
            See <https://github.com/feschber/lan-mouse/> for available options.
          '';
        };
      };

      config = mkIf cfg.enable {

        programs.lan-mouse = {
          enable = true;
          systemd = true;
          settings = cfg.settings;
        };
      };
    };
}
