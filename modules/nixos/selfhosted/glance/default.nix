{
  username,
  lib,
  config,
  ...
}: let
  home = import ./home.nix;
in {
  services = {
    glance = {
      enable = true;
      openFirewall = true;
      settings = {
        server = {
          host = "0.0.0.0";
          port = 5678;
        };
        branding = {
          custom-footer = "<p><a href='https://tux.rs'>${username}</a></p>";
        };
        pages = [
          home.page
        ];
      };
    };

    nginx = {
      enable = lib.mkForce true;
      virtualHosts = {
        "home.tux.rs" = {
          forceSSL = true;
          useACMEHost = "tux.rs";
          locations = {
            "/" = {
              proxyPass = "http://${config.services.glance.settings.server.host}:${toString config.services.glance.settings.server.port}";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
