{
  flake.modules.nixos.networking = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.networking.mullvad-vpn;
  in {
    options.tnix.networking.mullvad-vpn = {
      enable = lib.mkEnableOption "Mullvad VPN";
    };

    config = lib.mkIf cfg.enable {
      services.mullvad-vpn = {
        enable = true;
        gui.enable = true;
      };
    };
  };
}
