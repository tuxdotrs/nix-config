{
  flake.modules.nixos.services = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.services.uptime-kuma;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.uptime-kuma = {
      enable = lib.mkEnableOption "Uptime Kuma";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Uptime Kuma listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1111;
        description = "Port on which Uptime Kuma listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Uptime Kuma is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for Uptime Kuma";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for Uptime Kuma";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.services.uptime-kuma.domain must be set when tnix.services.uptime-kuma.enable is true.";
        }
      ];

      services = {
        uptime-kuma = {
          enable = true;
          settings = {
            HOST = cfg.host;
            PORT = port;
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
          uptime-kuma = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "uptime-kuma";
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
