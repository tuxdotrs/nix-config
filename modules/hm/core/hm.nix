{
  flake.modules.homeManager.core =
    { userName, ... }:
    {
      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";

      home = {
        username = "${userName}";
        homeDirectory = "/home/${userName}";
      };
    };
}
