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

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/docker/volumes/aiostreams/_data";
          description = "Directory to store persistent AIOStreams data";
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
        virtualisation.oci-containers.containers.aiostreams = {
          autoStart = true;
          image = "ghcr.io/viren070/aiostreams:latest";
          ports = [
            "${toString cfg.port}:3000"
          ];

          environment = cfg.environment;
          environmentFiles = [ cfg.environmentFile ];
          volumes = [
            "${cfg.dataDir}:/app/data"
          ];
        };

        services.nginx.virtualHosts = {
          "${cfg.environment.ADDON_ID}" = {
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
