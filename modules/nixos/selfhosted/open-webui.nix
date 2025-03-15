{
  lib,
  config,
  ...
}: {
  services = {
    open-webui = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
      port = 1111;
      environment = {
        WEBUI_URL = "https://chat.tux.rs";
        ENABLE_OLLAMA_API = "True";
        OLLAMA_BASE_URL = "http://pc:11434";
      };
    };

    nginx = {
      enable = lib.mkForce true;
      virtualHosts = {
        "chat.tux.rs" = {
          forceSSL = true;
          useACMEHost = "tux.rs";
          locations = {
            "/" = {
              proxyPass = "http://${config.services.open-webui.host}:${toString config.services.open-webui.port}";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}
