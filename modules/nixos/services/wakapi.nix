{
  flake.modules.nixos.services = {
    config,
    lib,
    options,
    ...
  }: let
    cfg = config.tnix.services.wakapi;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.wakapi = {
      enable = lib.mkEnableOption "Wakapi";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Wakapi listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1117;
        description = "Port on which Wakapi listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Wakapi is available";
      };

      environmentFiles = options.services.wakapi.environmentFiles;

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for Wakapi";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for Wakapi";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.services.wakapi.domain must be set when tnix.services.wakapi.enable is true.";
        }
      ];

      services = {
        wakapi = {
          enable = true;

          environmentFiles = cfg.environmentFiles;

          settings = {
            app.avatar_url_template = "https://www.gravatar.com/avatar/{email_hash}.png";

            db = {
              dialect = "postgres";
              host = "/run/postgresql";
              port = 5432;
              name = "wakapi";
              user = "wakapi";
            };

            server = {
              port = cfg.port;
              public_url = "https://${cfg.domain}";
            };

            security = {
              allow_signup = false;
              disable_frontpage = true;
            };
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
          wakapi = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "wakapi";
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
          ensureDatabases = ["wakapi"];
          ensureUsers = [
            {
              name = "wakapi";
              ensureDBOwnership = true;
            }
          ];
        };
      };
    };
  };
}
