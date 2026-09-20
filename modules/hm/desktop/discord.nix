{
  flake.modules.homeManager.desktop = {
    inputs,
    userName,
    ...
  }: {
    imports = [
      inputs.nixcord.homeModules.nixcord
    ];

    programs.nixcord = {
      enable = true;
      user = userName;
      discord = {
        enable = true;
        vencord.enable = true;
      };
      vesktop.enable = true;
      config = {
        themeLinks = [
          "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/archive/flavors/spotify-text.theme.css"
        ];
        frameless = true;
        plugins = {
          hideMedia.enable = true;
          anonymiseFileNames.enable = true;
          copyFileContents.enable = true;
          noTypingAnimation.enable = true;
          readAllNotificationsButton.enable = true;
          silentTyping.enable = true;
          validUser.enable = true;
          biggerStreamPreview.enable = true;
          ignoreActivities = {
            enable = true;
            ignorePlaying = true;
            ignoreWatching = true;
          };
          sortFriendRequests = {
            enable = true;
            showDates = true;
          };
        };
      };
    };
  };
}
