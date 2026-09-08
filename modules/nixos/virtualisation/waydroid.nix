{
  flake.modules.nixos.virtualisation =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.tnix.virtualisation;
    in
    {
      options.tnix.virtualisation.waydroid = {
        enable = lib.mkEnableOption "Waydroid Android container";
      };

      config = lib.mkIf cfg.waydroid.enable {
        virtualisation.waydroid.enable = true;
      };
    };
}
