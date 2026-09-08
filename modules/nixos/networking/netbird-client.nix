{
  flake.modules.nixos.networking =
    {
      config,
      lib,
      hostName,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.networking.netbird-client;
    in
    {
      options.tnix.networking.netbird-client = {
        enable = mkEnableOption "Enable netbird client";
      };

      config = mkIf cfg.enable {
        services.netbird.clients = {
          ${hostName} = {
            port = 61820;
            login = {
              enable = true;
              setupKeyFile = config.sops.secrets.netbird-key.path;
            };
            bin.suffix = "";
          };
        };
      };
    };
}
