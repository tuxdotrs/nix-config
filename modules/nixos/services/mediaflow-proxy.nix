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
    in
    {
      options.tnix.services.mediaflow-proxy = {
        enable = mkEnableOption "Enable MediaFlow Proxy";

        port = mkOption {
          type = types.int;
          default = 8888;
        };

        domain = mkOption {
          type = types.str;
          default = "";
        };

        environmentFile = mkOption {
          type = with types; path;
          default = "";
        };
      };

      config = mkIf cfg.enable {
        virtualisation.oci-containers.containers.mediaflow-proxy = {
          autoStart = true;
          image = "ghcr.io/mhdzumair/mediaflow-proxy-light:latest";
          ports = [
            "${toString cfg.port}:8888"
          ];
          environment = {
            APP__SERVER__HOST = "0.0.0.0";
            APP__SERVER__PORT = "${toString cfg.port}";
          };
          environmentFiles = [ cfg.environmentFile ];
        };

        services.nginx.virtualHosts.${cfg.domain} = {
          forceSSL = true;
          useACMEHost = config.tnix.services.nginx.domain;
          locations."/" = {
            proxyPass = "http://localhost:${toString cfg.port}";
            proxyWebsockets = true;
          };
        };
      };
    };
}
