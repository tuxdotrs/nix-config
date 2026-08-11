{
  flake.modules.droid.core = {
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
