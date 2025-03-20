{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # Metamask
      {id = "gppongmhjkpfnbhagpmjfkannfbllamg";} # Wappalyzer
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bitwarden
      {id = "bfnaelmomeimhlpmgjnjophhpkkoljpa";} # Phantom
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # DarkReader
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };
}
