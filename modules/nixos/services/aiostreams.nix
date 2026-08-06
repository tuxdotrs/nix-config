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
      port = toString cfg.port;
      acmeHost = config.tnix.services.nginx.domain;
    in
    {
      options.tnix.services.aiostreams = {
        enable = mkEnableOption "AIOStreams";

        port = mkOption {
          type = types.port;
          default = 3000;
          description = "Port on which AIOStreams listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which nginx serves AIOStreams (disabled when empty)";
        };

        image = mkOption {
          type = types.str;
          default = "ghcr.io/viren070/aiostreams:latest";
          description = "Container image to use";
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/docker/volumes/aiostreams/_data";
          description = "Directory to store persistent AIOStreams data";
        };

        environmentFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Environment file with secrets passed to the container";
        };
      };

      config = mkIf cfg.enable {
        virtualisation.oci-containers.containers.aiostreams = {
          image = cfg.image;
          ports = [
            "127.0.0.1:${port}:3000"
          ];
          environment = {
            ADDON_ID = cfg.domain;
            BASE_URL = "https://${cfg.domain}";
          };
          environmentFiles = optional (cfg.environmentFile != null) cfg.environmentFile;
          volumes = [
            "${cfg.dataDir}:/app/data"
          ];
        };

        services.nginx.virtualHosts.${cfg.domain} = mkIf (cfg.domain != "") {
          forceSSL = acmeHost != "";
          useACMEHost = mkIf (acmeHost != "") acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${port}";
          };
        };
      };
    };
}
