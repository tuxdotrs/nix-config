{
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.gitea;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.gitea = {
      enable = lib.mkEnableOption "Gitea";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Gitea listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1114;
        description = "Port on which Gitea listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Gitea is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for Gitea";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for Gitea";
      };
    };

    config = lib.mkIf cfg.enable {
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
              SSH_PORT = lib.head config.services.openssh.ports;
            };
          };
          database = {
            type = "postgres";
            name = "gitea";
            user = "gitea";
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
          ensureDatabases = ["gitea"];
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
