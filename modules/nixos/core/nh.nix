{
  flake.modules.nixos.core =
    {
      config,
      userName,
      ...
    }:
    {
      programs.nh = {
        enable = true;

        clean = {
          enable = !config.nix.gc.automatic;
          dates = "weekly";
        };

        flake = "/home/${userName}/Projects/nixos-config";
      };
    };
}
