{
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.forgejo;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.forgejo = {
      enable = lib.mkEnableOption "Forgejo";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Forgejo listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1114;
        description = "Port on which Forgejo listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Forgejo is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for Forgejo";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for Forgejo";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.services.forgejo.domain must be set when tnix.services.forgejo.enable is true.";
        }
      ];

      services = {
        forgejo = {
          enable = true;
          settings = {
            service.DISABLE_REGISTRATION = true;
            server = {
              HTTP_ADDR = cfg.host;
              HTTP_PORT = cfg.port;
              ROOT_URL = "https://${cfg.domain}";
              SSH_PORT = lib.head config.services.openssh.ports;
            };
            "git.timeout" = {
              DEFAULT = 3600;
              MIGRATE = 3600;
              MIRROR = 3600;
              CLONE = 3600;
              PULL = 3600;
              GC = 3600;
            };
          };
          database = {
            type = "postgres";
            name = "forgejo";
            user = "forgejo";
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
          forgejo = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "forgejo";
            protocol = "http";
            targets = [
              {
                hostname = cfg.host;
                method = "http";
                port = cfg.port;
                healthcheck = {
                  hostname = cfg.host;
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
          ensureDatabases = ["forgejo"];
          ensureUsers = [
            {
              name = "forgejo";
              ensureDBOwnership = true;
            }
          ];
        };
      };
    };
  };
}
