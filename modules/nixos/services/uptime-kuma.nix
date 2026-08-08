{
  flake.modules.nixos.services =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.tnix.services.uptime-kuma;
      port = toString cfg.port;
      acmeHost = config.tnix.services.nginx.domain;
    in
    {
      options.tnix.services.uptime-kuma = {
        enable = mkEnableOption "Uptime Kuma";

        port = mkOption {
          type = types.port;
          default = 1111;
          description = "Port on which Uptime Kuma listens";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          description = "Domain on which nginx serves Uptime Kuma (disabled when empty)";
        };
      };

      config = mkIf cfg.enable {
        services = {
          uptime-kuma = {
            enable = true;
            settings = {
              HOST = "127.0.0.1";
              PORT = port;
            };
          };

          nginx.virtualHosts.${cfg.domain} = mkIf (cfg.domain != "") {
            forceSSL = acmeHost != "";
            useACMEHost = mkIf (acmeHost != "") acmeHost;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${port}";
            };
          };
        };
      };
    };
}
