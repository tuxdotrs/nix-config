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

        environment = mkOption {
          type = with types; attrsOf str;
          default = { };
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

          environment = cfg.environment;
          environmentFiles = [ cfg.environmentFile ];
        };

        services.nginx.virtualHosts = {
          "mf-proxy.lab.tux.rs" = {
            forceSSL = true;
            useACMEHost = "lab.tux.rs";
            locations = {
              "/" = {
                proxyPass = "http://localhost:${toString cfg.port}";
              };
            };
          };
        };
      };
    };
}
