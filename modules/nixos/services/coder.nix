{
  flake.modules.nixos.services = {
    config,
    lib,
    options,
    ...
  }: let
    cfg = config.tnix.services.coder;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    options.tnix.services.coder = {
      enable = lib.mkEnableOption "Coder";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Coder listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1116;
        description = "Port on which Coder listens";
      };

      environment = options.services.coder.environment;

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Coder is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for Coder";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for Coder";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.services.coder.domain must be set when tnix.services.coder.enable is true.";
        }
      ];

      users.users.coder.extraGroups = ["docker"];

      services = {
        coder = {
          enable = true;
          accessUrl = "https://${cfg.domain}";
          listenAddress = "${cfg.host}:${port}";
          environment = cfg.environment;
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
          coder = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "coder";
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
