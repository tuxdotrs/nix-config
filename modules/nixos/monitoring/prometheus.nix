{
  flake.modules.nixos.monitoring = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.monitoring.prometheus;
  in {
    options.tnix.monitoring.prometheus = {
      enable = lib.mkEnableOption "Prometheus (remote-write receiver for host metrics)";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Prometheus listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9090;
        description = "Port on which Prometheus listens";
      };

      retention = lib.mkOption {
        type = lib.types.str;
        default = "30d";
        description = "How long Prometheus keeps metrics";
      };
    };

    config = lib.mkIf cfg.enable {
      services.prometheus = {
        enable = true;
        listenAddress = cfg.host;
        port = cfg.port;
        retentionTime = cfg.retention;
        # Hosts behind CGNAT can't be scraped, so Alloy pushes to /api/v1/write.
        extraFlags = ["--web.enable-remote-write-receiver"];
        globalConfig.scrape_interval = "10s";
      };
    };
  };
}
