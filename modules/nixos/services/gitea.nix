{
  flake.modules.nixos.services =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.gitea;
      port = toString cfg.port;
      acmeHost = config.tnix.services.nginx.domain;
    in
    {
      options.tnix.services.gitea = {
        enable = mkEnableOption "Gitea";

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host on which Gitea listens";
        };

        port = mkOption {
          type = types.port;
          default = 1114;
          description = "Port on which Gitea listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which Gitea is available";
        };

        configureNginx = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Nginx as a reverse proxy for Gitea";
        };

        configurePangolin = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Pangolin as a reverse proxy for Gitea";
        };
      };

      config = mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.domain != "";
            message = "tnix.services.gitea.domain must be set when tnix.services.gitea.enable is true.";
          }
        ];

        services = {
          gitea = {
            enable = true;
            settings = {
              service.DISABLE_REGISTRATION = true;
              server = {
                HTTP_ADDR = cfg.host;
                HTTP_PORT = cfg.port;
                DOMAIN = cfg.domain;
                ROOT_URL = "https://${cfg.domain}";
              };
            };
            database = {
              type = "postgres";
              name = "gitea";
              user = "gitea";
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
            gitea = {
              auth = {
                sso-enabled = false;
              };
              full-domain = cfg.domain;
              name = "gitea";
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
            ensureDatabases = [ "gitea" ];
            ensureUsers = [
              {
                name = "gitea";
                ensureDBOwnership = true;
              }
            ];
          };
        };
      };
    };
}
