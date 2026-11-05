{
  flake.modules.nixos.monitoring = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.monitoring.loki;
    dataDir = config.services.loki.dataDir;
  in {
    options.tnix.monitoring.loki = {
      enable = lib.mkEnableOption "Loki";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Loki listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3100;
        description = "Port on which Loki listens";
      };

      retention = lib.mkOption {
        type = lib.types.str;
        default = "30d";
        description = "How long Loki keeps logs";
      };
    };

    config = lib.mkIf cfg.enable {
      services.loki = {
        enable = true;
        configuration = {
          auth_enabled = false;

          server = {
            http_listen_address = cfg.host;
            http_listen_port = cfg.port;
            grpc_listen_address = "127.0.0.1";
            grpc_listen_port = 9096;
          };

          # Address the query frontend advertises to queriers. Without this,
          # Loki auto-detects an interface IP (e.g. docker0's 172.17.0.1), which
          # doesn't match the 127.0.0.1 gRPC listener, so every query hangs.
          frontend.address = "127.0.0.1";

          common = {
            path_prefix = dataDir;
            replication_factor = 1;
            ring = {
              instance_addr = "127.0.0.1";
              kvstore.store = "inmemory";
            };
            storage.filesystem = {
              chunks_directory = "${dataDir}/chunks";
              rules_directory = "${dataDir}/rules";
            };
          };

          schema_config.configs = [
            {
              from = "2026-01-01";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];

          limits_config.retention_period = cfg.retention;

          compactor = {
            working_directory = "${dataDir}/compactor";
            retention_enabled = true;
            delete_request_store = "filesystem";
          };

          analytics.reporting_enabled = false;
        };
      };
    };
  };
}
