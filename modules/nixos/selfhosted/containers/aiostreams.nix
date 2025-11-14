{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.tux.containers.aiostreams;
in {
  options.tux.containers.aiostreams = {
    enable = mkEnableOption "Enable AIOStreams";

    port = mkOption {
      type = types.int;
      default = 3000;
    };

    environment = mkOption {
      type = with types; attrsOf str;
      default = {};
    };

    environmentFiles = mkOption {
      type = with types; listOf path;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.aiostreams = {
      autoStart = true;
      image = "ghcr.io/viren070/aiostreams:latest";
      ports = [
        "${toString cfg.port}:3000"
      ];

      environment = cfg.environment;
      environmentFiles = cfg.environmentFiles;
    };

    services.nginx.virtualHosts = {
      "${cfg.environment.ADDON_ID}" = {
        forceSSL = true;
        useACMEHost = "tux.rs";
        locations = {
          "/" = {
            proxyPass = "http://localhost:${toString cfg.port}";
          };
        };
      };
    };
  };
}
