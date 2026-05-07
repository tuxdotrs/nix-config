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
      hyprland-git = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system};
      awww = inputs.awww.packages.${prev.stdenv.hostPlatform.system}.awww;
      vicinae-extensions = inputs.vicinae-extensions.packages.${prev.stdenv.hostPlatform.system};
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };

    nur = inputs.nur.overlays.default;
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
