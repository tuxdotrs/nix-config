{
  flake.modules.nixos.services =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.uptime-kuma;
      port = toString cfg.port;
      acmeHost = config.tnix.services.nginx.domain;
    in
    {
      options.tnix.services.uptime-kuma = {
        enable = mkEnableOption "Uptime Kuma";

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host on which Uptime Kuma listens";
        };

        port = mkOption {
          type = types.port;
          default = 1111;
          description = "Port on which Uptime Kuma listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which Uptime Kuma is available";
        };

        configureNginx = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Nginx as a reverse proxy for Uptime Kuma";
        };
      };

      config = mkIf cfg.enable {
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

          nginx.virtualHosts.${cfg.domain} = mkIf cfg.configureNginx {
            forceSSL = acmeHost != "";
            useACMEHost = mkIf (acmeHost != "") acmeHost;
            locations."/" = {
              proxyPass = "http://${cfg.host}:${port}";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
}
