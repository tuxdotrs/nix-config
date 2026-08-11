{
  flake.modules.nixOnDroid.core = {
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
