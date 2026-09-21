{
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.vaultwarden;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.vaultwarden = {
      enable = lib.mkEnableOption "Vaultwarden";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Vaultwarden listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1112;
        description = "Port on which Vaultwarden listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Vaultwarden is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for Vaultwarden";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for Vaultwarden";
      };
    };

    config = lib.mkIf cfg.enable {
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

        nginx.virtualHosts.${cfg.domain} = lib.mkIf cfg.configureNginx {
          forceSSL = acmeHost != "";
          useACMEHost = lib.mkIf (acmeHost != "") acmeHost;
          locations."/" = {
            proxyPass = "http://${cfg.host}:${port}";
            proxyWebsockets = true;
          };
        };

        newt.blueprint.proxy-resources = lib.mkIf cfg.configurePangolin {
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
          ensureDatabases = ["vaultwarden"];
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
