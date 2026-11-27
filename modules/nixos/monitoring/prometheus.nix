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

        # Numeric sort key so dashboards can order hosts manually.
        # This nixpkgs' `rules` is a list of strings joined into one rules
        # file, so the group is passed as a single JSON document.
        rules = [
          (builtins.toJSON {
            groups = [
              {
                name = "host_order";
                rules = [
                  {
                    record = "host_order";
                    expr = "vector(1)";
                    labels = {host = "sirius";};
                  }
                  {
                    record = "host_order";
                    expr = "vector(2)";
                    labels = {host = "canopus";};
                  }
                  {
                    record = "host_order";
                    expr = "vector(3)";
                    labels = {host = "arcturus";};
                  }
                  {
                    record = "host_order";
                    expr = "vector(4)";
                    labels = {host = "alpha";};
                  }
                  {
                    record = "host_order";
                    expr = "vector(5)";
                    labels = {host = "vega";};
                  }
                  {
                    record = "host_order";
                    expr = "vector(6)";
                    labels = {host = "capella";};
                  }
                ];
              }
            ];
          })
        ];
      };
    };
  };
}
