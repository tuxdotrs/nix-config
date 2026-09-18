{
  flake.modules.nixos.services = {
    config,
    lib,
    options,
    ...
  }:
    with lib; let
      cfg = config.tnix.services.coder;
      port = toString cfg.port;
    in {
      options.tnix.services.coder = {
        enable = mkEnableOption "Coder";

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host on which Coder listens";
        };

        port = mkOption {
          type = types.port;
          default = 1116;
          description = "Port on which Coder listens";
        };

        environment = options.services.coder.environment;

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which Coder is available";
        };

        configureNginx = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Nginx as a reverse proxy for Coder";
        };

        configurePangolin = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Pangolin as a reverse proxy for Coder";
        };
      };

      config = mkIf cfg.enable {
        users.users.coder.extraGroups = ["docker"];

        services = {
          coder = {
            enable = true;
            accessUrl = "https://${cfg.domain}";
            listenAddress = "${cfg.host}:${port}";
            environment = cfg.environment;
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
