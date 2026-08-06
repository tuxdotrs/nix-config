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
      port = toString cfg.port;
      acmeHost = config.tnix.services.nginx.domain;
    in
    {
      options.tnix.services.vaultwarden = {
        enable = mkEnableOption "Vaultwarden";

        port = mkOption {
          type = types.port;
          default = 8000;
          description = "Port on which Vaultwarden listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which nginx serves Vaultwarden (disabled when empty)";
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

          nginx.virtualHosts.${cfg.domain} = mkIf (cfg.domain != "") {
            forceSSL = acmeHost != "";
            useACMEHost = mkIf (acmeHost != "") acmeHost;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${port}";
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
