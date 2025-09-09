{inputs, ...}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
    dorion.enable = true;
    config = {
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/archive/flavors/spotify-text.theme.css"
      ];
      frameless = true;
      plugins = {
        hideMedia.enable = true;
        ignoreActivities = {
          enable = true;
          ignorePlaying = true;
          ignoreWatching = true;
        };
      };
    };
    dorion = {
      theme = "dark";
      zoom = "1.1";
      blur = "acrylic";
      sysTray = true;
      openOnStartup = true;
      autoClearCache = true;
      disableHardwareAccel = false;
      rpcServer = true;
      rpcProcessScanner = true;
      pushToTalk = true;
      pushToTalkKeys = ["RControl"];
      desktopNotifications = true;
      unreadBadge = true;
    };
  };
}
