{
  lib,
  config,
  ...
}: {
  services = {
    send = {
      enable = true;
      port = 1443;

      environment = {
        DEFAULT_DOWNLOADS = 5;
        DETECT_BASE_URL = true;
      };
    };

    nginx = {
      enable = lib.mkForce true;
      virtualHosts = {
        "share.tux.rs" = {
          forceSSL = true;
          useACMEHost = "tux.rs";
          locations = {
            "/" = {
              proxyPass = "http://${config.services.send.host}:${toString config.services.send.port}";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
