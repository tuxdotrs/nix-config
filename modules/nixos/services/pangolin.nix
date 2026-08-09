{
  flake.modules.nixos.services =
    {
      config,
      lib,
      userEmail,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.pangolin;
    in
    {
      options.tnix.services.pangolin = {
        enable = mkEnableOption "Pangolin";

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which nginx serves MediaFlow Proxy (disabled when empty)";
        };

        baseDomain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which nginx serves MediaFlow Proxy (disabled when empty)";
        };

        environmentFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "Environment file with secrets passed to Pangolin";
        };
      };

      config = mkIf cfg.enable {
        services = {
          pangolin = {
            enable = true;
            package = (
              pkgs.fosrl-pangolin.override {
                databaseType = "pg";
              }
            );
            openFirewall = true;
            baseDomain = cfg.baseDomain;
            dashboardDomain = cfg.domain;
            environmentFile = cfg.environmentFile;
            letsEncryptEmail = userEmail;

            settings = {
              app.dashboard_url = "https://${config.services.pangolin.dashboardDomain}";
              domains.domain1 = {
                base_domain = config.services.pangolin.baseDomain;
                prefer_wildcard_cert = false;
              };
              server = {
                external_port = 3000;
                internal_port = 3001;
                next_port = 3002;
                integration_port = 3003;
                # needs to be set, otherwise this fails silently
                # see https://github.com/fosrl/newt/issues/37
                internal_hostname = "localhost";
              };
              gerbil.base_endpoint = config.services.pangolin.dashboardDomain;
              flags = {
                disable_signup_without_invite = true;
                enable_integration_api = false;
                allow_raw_resources = true;
                disable_enterprise_features = true;
              };
              postgres.connection_string = "postgresql:///pangolin?host=/run/postgresql";
            };
          };

          postgresql = {
            enable = true;
            ensureDatabases = [ "pangolin" ];
            ensureUsers = [
              {
                name = "pangolin";
                ensureDBOwnership = true;
              }
            ];
          };
        };
      };
    };
}
