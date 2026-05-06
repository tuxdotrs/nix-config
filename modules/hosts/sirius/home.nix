{ config, ... }:
{
  flake.modules.homeManager.sirius = {
    imports = with config.flake.modules.homeManager; [
      desktop
    ];

    tnix.services.lan-mouse = {
      enable = true;
      settings = {
        clients = [
          {
            position = "bottom";
            hostname = "canopus";
            activate_on_startup = true;
            ips = [ "192.168.8.2" ];
          }
        ];
      };
    };

    home.stateVersion = "26.05";
  };
}
