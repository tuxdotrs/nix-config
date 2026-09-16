{
  flake.modules.nixos.core = {...}: {
    environment.enableAllTerminfo = true;
  };
}
