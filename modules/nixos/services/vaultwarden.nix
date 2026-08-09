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

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host on which Vaultwarden listens";
        };

        port = mkOption {
          type = types.port;
          default = 1112;
          description = "Port on which Vaultwarden listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which Vaultwarden is available";
        };

        configureNginx = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Nginx as a reverse proxy for Vaultwarden";
        };

        configurePangolin = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Pangolin as a reverse proxy for Vaultwarden";
        };
      };

      config = mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.domain != "";
            message = "tnix.services.vaultwarden.domain must be set when tnix.services.vaultwarden.enable is true.";
          }
        ];

        services = {
          vaultwarden = {
            enable = true;
            dbBackend = "postgresql";
            config = {
              ROCKET_ADDRESS = cfg.host;
              ROCKET_PORT = cfg.port;
              DOMAIN = "https://${cfg.domain}";

              DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
              ENABLE_WEBSOCKET = true;
              SIGNUPS_ALLOWED = true;
              DISABLE_ICON_DOWNLOAD = true;
            };
          };

          nginx.virtualHosts.${cfg.domain} = mkIf cfg.configureNginx {
            forceSSL = acmeHost != "";
            useACMEHost = mkIf (acmeHost != "") acmeHost;
            locations."/" = {
              proxyPass = "http://${cfg.host}:${port}";
              proxyWebsockets = true;
            };
          };

          newt.blueprint.proxy-resources = mkIf cfg.configurePangolin {
            vaultwarden = {
              auth = {
                sso-enabled = false;
              };
              full-domain = cfg.domain;
              name = "vaultwarden";
              protocol = "http";
              targets = [
                {
                  hostname = "localhost";
                  method = "http";
                  port = cfg.port;
                  healthcheck = {
                    hostname = "localhost";
                    port = cfg.port;
                    scheme = "http";
                    method = "GET";
                    path = "/";
                  };
                }
              ];
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
