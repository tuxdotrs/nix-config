{
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.aiostreams;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.aiostreams = {
      enable = lib.mkEnableOption "AIOStreams";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which AIOStreams listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Port on which AIOStreams listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which AIOStreams is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for AIOStreams";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for AIOStreams";
      };

      image = lib.mkOption {
        type = lib.types.str;
        default = "ghcr.io/viren070/aiostreams:latest";
        description = "Container image to use";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/docker/volumes/aiostreams/_data";
        description = "Directory to store persistent AIOStreams data";
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
          message = "tnix.services.aiostreams.domain must be set when tnix.services.aiostreams.enable is true.";
        }
      ];

      virtualisation.oci-containers.containers.aiostreams = {
        image = cfg.image;
        ports = [
          "${cfg.host}:${port}:3000"
        ];
        environment = {
          ADDON_ID = cfg.domain;
          BASE_URL = "https://${cfg.domain}";
        };
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
          aiostreams = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "aiostreams";
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
      };
    };
  };
}
