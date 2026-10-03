{
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.dbx;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.dbx = {
      enable = lib.mkEnableOption "DBX";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which DBX listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1119;
        description = "Port on which DBX listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which DBX is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for DBX";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for DBX";
      };

      image = lib.mkOption {
        type = lib.types.str;
        default = "t8y2/dbx:latest";
        description = "Container image to use";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/docker/volumes/dbx/_data";
        description = "Directory to store persistent DBX data";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Environment file with secrets passed to the container";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.services.dbx.domain must be set when tnix.services.dbx.enable is true.";
        }
      ];

      virtualisation.oci-containers.containers.dbx = {
        image = cfg.image;
        ports = [
          "${cfg.host}:${port}:4224"
        ];
        environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        volumes = [
          "${cfg.dataDir}:/app/data"
        ];
      };

      services = {
        nginx.virtualHosts.${cfg.domain} = lib.mkIf cfg.configureNginx {
          forceSSL = acmeHost != "";
          useACMEHost = lib.mkIf (acmeHost != "") acmeHost;
          locations."/" = {
            proxyPass = "http://${cfg.host}:${port}";
            proxyWebsockets = true;
          };
        };

        newt.blueprint.proxy-resources = lib.mkIf cfg.configurePangolin {
          dbx = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "dbx";
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
      };
    };
  };
}
