{
  pkgs,
  username,
  ...
}: {
  home.file.".mozilla/firefox/${username}/chrome".source = pkgs.firefox-mod-blur;

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };

    profiles = {
      ${username} = {
        id = 0;
        name = "tux";
        search = {
          force = true;
          default = "Google";
        };
        settings = {
          "general.smoothScroll" = true;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.compactmode.show" = true;
          "browser.tabs.firefox-view" = false;
          "browser.bookmarks.addedImportButton" = false;
          "extensions.pocket.enabled" = false;
          "browser.fullscreen.autohide" = false;
        };
        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          facebook-container
          metamask
          darkreader
          bitwarden
          wappalyzer
          clearurls
        ];
      };
    };
  };
}
