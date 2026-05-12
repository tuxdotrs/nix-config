{ config, ... }:
{
  flake.modules.homeManager.canopus = {
    imports = with config.flake.modules.homeManager; [
      desktop
    ];

    tnix.services.lan-mouse = {
      enable = true;
      settings = {
        authorized_fingerprints = {
          "f4:4b:17:61:f7:01:a4:a2:e1:c7:8c:1c:7a:f3:8b:87:14:3d:05:3d:a0:8b:cc:e7:88:d8:d8:d2:a4:c2:75:8b" =
            "sirius";
        };
      };
    };

    home.stateVersion = "26.05";
  };
}
