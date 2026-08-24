{
  inputs,
  ...
}:
{
  flake.overlays = {
    modifications = final: prev: {
      tnvim = inputs.tnvim.packages.${prev.stdenv.hostPlatform.system}.default;
      tshell = inputs.tshell.packages.${prev.stdenv.hostPlatform.system}.default;
      cyber-tux = inputs.cyber-tux.packages.${prev.stdenv.hostPlatform.system}.default;
      wezterm-git = inputs.wezterm-flake.packages.${prev.stdenv.hostPlatform.system}.default;
      hyprland-git = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system};
      awww = inputs.awww.packages.${prev.stdenv.hostPlatform.system}.awww;
      vicinae-extensions = inputs.vicinae-extensions.packages.${prev.stdenv.hostPlatform.system};
      voxtype = inputs.voxtype.packages.${prev.stdenv.hostPlatform.system};
      opencode-git = inputs.opencode.packages.${prev.stdenv.hostPlatform.system}.default;
      nix-index-small =
        inputs.nix-index-database.packages.${prev.stdenv.hostPlatform.system}.nix-index-with-small-db;
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };

    nur = inputs.nur.overlays.default;
    copyparty = inputs.copyparty.overlays.default;
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
