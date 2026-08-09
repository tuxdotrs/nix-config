{
  flake.modules.nixos.services =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.mediaflow-proxy;
      port = toString cfg.port;
      acmeHost = config.tnix.services.nginx.domain;
    in
    {
      options.tnix.services.mediaflow-proxy = {
        enable = mkEnableOption "MediaFlow Proxy";

        host = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "Host on which MediaFlow Proxy listens";
        };

        port = mkOption {
          type = types.port;
          default = 1113;
          description = "Port on which MediaFlow Proxy listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which MediaFlow Proxy is available";
        };

        configureNginx = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to configure Nginx as a reverse proxy for MediaFlow Proxy";
        };

        image = mkOption {
          type = types.str;
          default = "ghcr.io/mhdzumair/mediaflow-proxy-light:latest";
          description = "Container image to use";
        };

        environmentFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Environment file with secrets passed to the container";
        };
      };

      config = mkIf cfg.enable {
        assertions = [
          {
            assertion = !cfg.configureNginx || cfg.domain != "";
            message = "tnix.services.mediaflow-proxy.domain must be set when configureNginx is enabled.";
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
          environmentFiles = optional (cfg.environmentFile != null) cfg.environmentFile;
        };

        services.nginx.virtualHosts.${cfg.domain} = mkIf cfg.configureNginx {
          forceSSL = acmeHost != "";
          useACMEHost = mkIf (acmeHost != "") acmeHost;
          locations."/" = {
            proxyPass = "http://${cfg.host}:${port}";
            proxyWebsockets = true;
          };
        };
      };
    };
}
