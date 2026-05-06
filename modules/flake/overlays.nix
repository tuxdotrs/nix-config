{
  inputs,
  ...
}:
{
  flake.overlays = {
    modifications = final: prev: {
      tnvim = inputs.tnvim.packages.${prev.stdenv.hostPlatform.system}.default;
      tpanel = inputs.tpanel.packages.${prev.stdenv.hostPlatform.system}.default;
      ags = inputs.tpanel.packages.${prev.stdenv.hostPlatform.system}.ags.default;
      wezterm-git = inputs.wezterm-flake.packages.${prev.stdenv.hostPlatform.system}.default;
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues inputs.self.overlays;
      };
    };
}
