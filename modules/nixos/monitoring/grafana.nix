{
  flake.modules.nixos.monitoring = {
    config,
    lib,
    ...
  }: let
    cfg = config.tnix.monitoring.grafana;
    loki = config.tnix.monitoring.loki;
    prometheus = config.tnix.monitoring.prometheus;
  in {
    options.tnix.monitoring.grafana = {
      enable = lib.mkEnableOption "Grafana";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Grafana listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1115;
        description = "Port on which Grafana listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Grafana is available";
      };

      adminPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "File containing the Grafana admin password";
      };

      secretKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "File containing Grafana's secret key used to encrypt datasource secrets";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.monitoring.grafana.domain must be set when tnix.monitoring.grafana.enable is true.";
        }
        {
          assertion = cfg.adminPasswordFile != null && cfg.secretKeyFile != null;
          message = "tnix.monitoring.grafana.adminPasswordFile and secretKeyFile must be set when tnix.monitoring.grafana.enable is true.";
        }
      ];

      services.grafana = {
        enable = true;

        settings = {
          server = {
            http_addr = cfg.host;
            http_port = cfg.port;
            domain = cfg.domain;
            root_url = "https://${cfg.domain}";
          };

          security = {
            admin_password = "$__file{${toString cfg.adminPasswordFile}}";
            secret_key = "$__file{${toString cfg.secretKeyFile}}";
          };

          database = {
            type = "postgres";
            host = "/run/postgresql";
            name = "grafana";
            user = "grafana";
          };

          users.allow_sign_up = false;
          analytics.reporting_enabled = false;
        };

        provision = {
          enable = true;
          datasources.settings.datasources =
            lib.optional loki.enable {
              name = "Loki";
              type = "loki";
              uid = "loki";
              access = "proxy";
              url = "http://${loki.host}:${toString loki.port}";
              isDefault = true;
            }
            ++ lib.optional prometheus.enable {
              name = "Prometheus";
              type = "prometheus";
              uid = "prometheus";
              access = "proxy";
              url = "http://${prometheus.host}:${toString prometheus.port}";
              jsonData.timeInterval = "15s";
            };

          dashboards.settings.providers = [
            {
              name = "tnix";
              folder = "tnix";
              disableDeletion = true;
              allowUiUpdates = false;
              options.path = ./dashboards;
            }
          ];
        };
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = ["grafana"];
        ensureUsers = [
          {
            name = "grafana";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
