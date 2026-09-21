{inputs, ...}: {
  flake.modules.nixos.services = {
    config,
    lib,
    pkgs,
    options,
    ...
  }: let
    cfg = config.tnix.services.copyparty;
    port = toString cfg.port;
    acmeHost = config.tnix.services.nginx.domain;
  in {
    imports = [
      inputs.copyparty.nixosModules.default
    ];

    options.tnix.services.copyparty = {
      enable = lib.mkEnableOption "Copyparty";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host on which Copyparty listens";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 1115;
        description = "Port on which Copyparty listens";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain on which Copyparty is available";
      };

      accounts = options.services.copyparty.accounts;
      volumes = options.services.copyparty.volumes;

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy for Copyparty";
      };

      configurePangolin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Pangolin as a reverse proxy for Copyparty";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "tnix.services.copyparty.domain must be set when tnix.services.copyparty.enable is true.";
        }
      ];

      services = {
        copyparty = {
          enable = true;
          settings = {
            i = cfg.host;
            p = cfg.port;
            no-reload = true;
            ignored-flag = false;
          };
          accounts = cfg.accounts;
          volumes = cfg.volumes;
          package = pkgs.copyparty.override {
            extraPackages = [pkgs.exiftool];
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
          copyparty = {
            auth = {
              sso-enabled = false;
            };
            full-domain = cfg.domain;
            name = "copyparty";
            protocol = "http";
            targets = [
              {
                hostname = "localhost";
                method = "http";
                port = cfg.port;
                healthcheck = {
                  hostname = "localhost";
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
