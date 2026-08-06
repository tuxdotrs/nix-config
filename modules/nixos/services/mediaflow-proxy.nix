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

        port = mkOption {
          type = types.port;
          default = 8888;
          description = "Port on which MediaFlow Proxy listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which nginx serves MediaFlow Proxy (disabled when empty)";
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
        virtualisation.oci-containers.containers.mediaflow-proxy = {
          image = cfg.image;
          ports = [
            "${port}:${port}"
          ];
          environment = {
            APP__SERVER__HOST = "0.0.0.0";
            APP__SERVER__PORT = port;
          };
          environmentFiles = optional (cfg.environmentFile != null) cfg.environmentFile;
        };

        services.nginx.virtualHosts.${cfg.domain} = mkIf (cfg.domain != "") {
          forceSSL = acmeHost != "";
          useACMEHost = mkIf (acmeHost != "") acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${port}";
            proxyWebsockets = true;
          };
        };
      };
    };
}
