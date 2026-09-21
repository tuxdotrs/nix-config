{
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.mediaflow-proxy;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.mediaflow-proxy = {
      enable = lib.mkEnableOption "MediaFlow Proxy";

      host = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "Host on which MediaFlow Proxy listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1113;
        description = "Port on which MediaFlow Proxy listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which MediaFlow Proxy is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for MediaFlow Proxy";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for MediaFlow Proxy";
      };

      image = lib.mkOption {
        type = lib.types.str;
        default = "ghcr.io/mhdzumair/mediaflow-proxy-light:latest";
        description = "Container image to use";
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
          assertion = !cfg.configureNginx || cfg.domain != "";
          message = "tnix.services.mediaflow-proxy.domain must be set when tnix.services.mediaflow-proxy.configureNginx is enabled.";
        }
        {
          assertion = !cfg.configurePangolin || cfg.domain != "";
          message = "tnix.services.mediaflow-proxy.domain must be set when tnix.services.mediaflow-proxy.configurePangolin is enabled.";
        }
      ];

      virtualisation.oci-containers.containers.mediaflow-proxy = {
        image = cfg.image;
        ports = [
          "${cfg.host}:${port}:${port}"
        ];
        environment = {
          APP__SERVER__HOST = "0.0.0.0";
          APP__SERVER__PORT = port;
        };
        environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
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
          mediaflow-proxy = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "mediaflow-proxy";
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
