{
  flake.modules.nixos.monitoring = {
    config,
    lib,
    hostName,
    ...
  }: let
    cfg = config.tnix.monitoring.alloy;

    # Same credentials for the Loki and Prometheus endpoints.
    basicAuth = lib.optionalString (cfg.environmentFile != null) ''
      basic_auth {
        username = "${cfg.username}"
        password = sys.env("ALLOY_PASSWORD")
      }
    '';

    # Interfaces that are virtual/loopback; tunnels (wg*, nb-*) are kept but
    # filtered out of "internet usage" in the dashboard to avoid double counting.
    netdevExclude = "^(lo|veth.*|docker.*|br-.*|virbr.*|vnet.*|tap.*)$";
  in {
    options.tnix.monitoring.alloy = {
      enable = lib.mkEnableOption "Grafana Alloy journald log and host metrics shipping";

      lokiUrl = lib.mkOption {
        type = lib.types.str;
        default = "https://logs.tux.rs/loki/api/v1/push";
        description = "Loki push endpoint";
      };

      metrics = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to collect host metrics (CPU, memory, disk, network, temps) and push them to Prometheus";
        };

        url = lib.mkOption {
          type = lib.types.str;
          default = "https://metrics.tux.rs/api/v1/write";
          description = "Prometheus remote-write endpoint";
        };

        interval = lib.mkOption {
          type = lib.types.str;
          default = "10s";
          description = "How often host metrics are collected";
        };
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "alloy";
        description = "Basic auth username for the Loki and Prometheus endpoints (used only when environmentFile is set)";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Environment file containing ALLOY_PASSWORD; enables basic auth for logs and metrics when set";
      };
    };

    config = lib.mkIf cfg.enable {
      services.alloy = {
        enable = true;
        environmentFile = cfg.environmentFile;
      };

      environment.etc."alloy/metrics.alloy" = lib.mkIf cfg.metrics.enable {
        text = ''
          prometheus.exporter.unix "node" {
            netdev {
              device_exclude = "${netdevExclude}"
            }

            netclass {
              ignored_devices = "${netdevExclude}"
            }
          }

          discovery.relabel "node" {
            targets = prometheus.exporter.unix.node.targets

            rule {
              target_label = "instance"
              replacement  = "${hostName}"
            }

            rule {
              target_label = "host"
              replacement  = "${hostName}"
            }
          }

          prometheus.scrape "node" {
            targets         = discovery.relabel.node.output
            job_name        = "node"
            scrape_interval = "${cfg.metrics.interval}"
            forward_to      = [prometheus.remote_write.default.receiver]
          }

          prometheus.remote_write "default" {
            endpoint {
              url = "${cfg.metrics.url}"
              ${basicAuth}
            }
          }
        '';
      };

      environment.etc."alloy/config.alloy".text = ''
        loki.relabel "journal" {
          forward_to = []

          rule {
            source_labels = ["__journal__systemd_unit"]
            target_label  = "unit"
          }

          rule {
            source_labels = ["__journal__hostname"]
            target_label  = "host"
          }

          rule {
            source_labels = ["__journal_priority_keyword"]
            target_label  = "level"
          }

          rule {
            source_labels = ["__journal_syslog_identifier"]
            target_label  = "syslog_identifier"
          }
        }

        loki.source.journal "read" {
          max_age       = "12h"
          relabel_rules = loki.relabel.journal.rules
          forward_to    = [loki.write.default.receiver]
          labels        = {
            job = "systemd-journal",
          }
        }

        loki.write "default" {
          endpoint {
            url = "${cfg.lokiUrl}"
            ${basicAuth}
          }
        }
      '';
    };
  };
}
