{
  flake.modules.homeManager.desktop = {
    pkgs,
    config,
    ...
  }: let
    configDir = "${config.xdg.configHome}/BraveSoftware/Brave-Origin";

    extensionJson = ext: {
      name = "${configDir}/External Extensions/${ext.id}.json";
      value.text = builtins.toJSON {
        external_update_url = "https://clients2.google.com/service/update2/crx";
      };
    };

    extensions = [
      {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # Metamask
      {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # Wappalyzer
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "bfnaelmomeimhlpmgjnjophhpkkoljpa";} # Phantom
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # DarkReader
    ];
  in {
    programs.chromium = {
      enable = true;
      package = pkgs.brave-origin;
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
        "--force-device-scale-factor=1.0"
      ];
    };

    home.packages = [pkgs.brave];

    home.file = builtins.listToAttrs (map extensionJson extensions);
  };
}
