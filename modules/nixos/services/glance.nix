{
  flake.modules.nixos.services = {
    config,
    lib,
    userName,
    ...
  }: let
    cfg = config.tnix.services.glance;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;

    homepage = {
      name = "Dashboard - tux";
      width = "slim";
      hide-desktop-navigation = true;
      center-vertically = true;
      columns = [
        {
          size = "full";
          widgets = [
            {
              type = "search";
              autofocus = true;
            }
            {
              type = "markets";
              markets = [
                {
                  symbol = "BTC-USD";
                  name = "Bitcoin";
                  chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:BTCUSD";
                }
                {
                  symbol = "ETH-USD";
                  name = "Ethereum";
                  chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:ETHUSD";
                }
                {
                  symbol = "SOL-USD";
                  name = "Solana";
                  chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:SOLUSD";
                }
              ];
            }
            {
              type = "monitor";
              cache = "1m";
              title = "Services";
              sites = [
                {
                  title = "Gitea";
                  url = "https://git.tux.rs";
                  icon = "si:gitea";
                }
                {
                  title = "Coder";
                  url = "https://coder.tux.rs";
                  icon = "si:coder";
                }
                {
                  title = "Wakapi";
                  url = "https://wakapi.tux.rs";
                  icon = "si:wakatime";
                }
              ];
            }
          ];
        }
      ];
    };
  in {
    options.tnix.services.glance = {
      enable = lib.mkEnableOption "Glance";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Glance listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1118;
        description = "Port on which Glance listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Glance is available";
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for glance";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for glance";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.services.glance.domain must be set when tnix.services.glance.enable is true.";
        }
      ];

      services = {
        glance = {
          enable = true;
          settings = {
            server = {
              host = cfg.host;
              port = cfg.port;
            };
            branding = {
              custom-footer = "<p><a href='https://tux.rs'>${userName}</a></p>";
            };
            pages = [
              homepage
            ];
          };
        };

        nginx.virtualHosts.${cfg.domain} = lib.mkIf cfg.configureNginx {
          forceSSL = acmeHost != "";
          useACMEHost = lib.mkIf (acmeHost != "") acmeHost;
          locations."/" = {
            proxyPass = "http://${cfg.host}:${port}";
            proxyWebsockets = true;
          };
        };

        newt.blueprint.proxy-resources = lib.mkIf cfg.configurePangolin {
          glance = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "glance";
            protocol = "http";
            targets = [
              {
                hostname = cfg.host;
                method = "http";
                port = cfg.port;
                healthcheck = {
                  hostname = cfg.host;
                  port = cfg.port;
                  scheme = "http";
                  method = "GET";
                  path = "/";
                };
              }
            ];
          };
        };
      };
    };
  };
}
