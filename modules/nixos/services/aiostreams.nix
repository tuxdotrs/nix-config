{
  flake.modules.nixos.services =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.aiostreams;
    in
    {
      options.tnix.services.aiostreams = {
        enable = mkEnableOption "Enable AIOStreams";

        port = mkOption {
          type = types.int;
          default = 3000;
        };

        domain = mkOption {
          type = types.str;
          default = "";
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/docker/volumes/aiostreams/_data";
          description = "Directory to store persistent AIOStreams data";
        };

        environmentFile = mkOption {
          type = with types; path;
          default = "";
        };
      };

      config = mkIf cfg.enable {
        virtualisation.oci-containers.containers.aiostreams = {
          autoStart = true;
          image = "ghcr.io/viren070/aiostreams:latest";
          ports = [
            "${toString cfg.port}:3000"
          ];
          environment = {
            ADDON_ID = "${cfg.domain}";
            BASE_URL = "https://${cfg.domain}";
          };
          environmentFiles = [ cfg.environmentFile ];
          volumes = [
            "${cfg.dataDir}:/app/data"
          ];
        };

        services.nginx.virtualHosts.${cfg.domain} = {
          forceSSL = true;
          useACMEHost = config.tnix.services.nginx.domain;
          locations."/" = {
            proxyPass = "http://localhost:${toString cfg.port}";
          };
        };
      };
    };
}
