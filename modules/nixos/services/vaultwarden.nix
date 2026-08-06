{
  flake.modules.nixos.services =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.vaultwarden;
    in
    {
      options.tnix.services.vaultwarden = {
        enable = mkEnableOption "Enable Vaultwarden";

        port = mkOption {
          type = types.int;
          default = 8000;
        };

        domain = mkOption {
          type = types.str;
          default = "";
        };
      };

      config = mkIf cfg.enable {
        services = {
          vaultwarden = {
            enable = true;
            dbBackend = "postgresql";
            config = {
              ROCKET_ADDRESS = "127.0.0.1";
              ROCKET_PORT = cfg.port;
              DOMAIN = "https://${cfg.domain}";

              DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
              ENABLE_WEBSOCKET = true;
              SIGNUPS_ALLOWED = true;
              DISABLE_ICON_DOWNLOAD = true;
            };
          };

          nginx.virtualHosts.${cfg.domain} = {
            forceSSL = true;
            useACMEHost = config.tnix.services.nginx.domain;
            locations."/" = {
              proxyPass = "http://localhost:${toString cfg.port}";
              proxyWebsockets = true;
            };
          };

          postgresql = {
            enable = true;
            ensureDatabases = [ "vaultwarden" ];
            ensureUsers = [
              {
                name = "vaultwarden";
                ensureDBOwnership = true;
              }
            ];
          };
        };
      };
    };
}
