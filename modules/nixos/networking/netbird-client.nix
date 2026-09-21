{
  flake.modules.nixos.networking = {
    config,
    lib,
    hostName,
    ...
  }: let
    cfg = config.tnix.networking.netbird-client;
  in {
    options.tnix.networking.netbird-client = {
      enable = lib.mkEnableOption "Enable netbird client";
    };

    config = lib.mkIf cfg.enable {
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
