{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    awesome = inputs.nixpkgs-f2k.packages.${prev.stdenv.hostPlatform.system}.awesome-git;
    ghostty = inputs.ghostty.packages.${prev.stdenv.hostPlatform.system}.default;
    tawm = inputs.tawm.packages.${prev.stdenv.hostPlatform.system}.default;
    tnvim = inputs.tnvim.packages.${prev.stdenv.hostPlatform.system}.default;
    tpanel = inputs.tpanel.packages.${prev.stdenv.hostPlatform.system}.default;
    ags = inputs.tpanel.packages.${prev.stdenv.hostPlatform.system}.ags.default;
    tfolio = inputs.tfolio.packages.${prev.stdenv.hostPlatform.system}.default;
    trok = inputs.trok.packages.${prev.stdenv.hostPlatform.system}.default;
    cyber-tux = inputs.cyber-tux.packages.${prev.stdenv.hostPlatform.system}.default;
    hyprland-git = inputs.hyprland.packages.${prev.stdenv.hostPlatform.system};
    hyprland-plugins = inputs.hyprland-plugins.packages.${prev.stdenv.hostPlatform.system};
    wezterm-git = inputs.wezterm-flake.packages.${prev.stdenv.hostPlatform.system}.default;
    awww = inputs.awww.packages.${prev.stdenv.hostPlatform.system}.awww;
    vicinae-extensions = inputs.vicinae-extensions.packages.${prev.stdenv.hostPlatform.system};
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  nur = inputs.nur.overlays.default;

  nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;
}
