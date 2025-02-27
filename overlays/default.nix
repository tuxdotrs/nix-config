{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    awesome = inputs.nixpkgs-f2k.packages.${prev.system}.awesome-git;
    ghostty = inputs.ghostty.packages.${prev.system}.default;
    tawm = inputs.tawm.packages.${prev.system}.default;
    tnvim = inputs.tnvim.packages.${prev.system}.default;
    tfolio = inputs.tfolio.packages.${prev.system}.default;
    cyber-tux = inputs.cyber-tux.packages.${prev.system}.default;
    discord = prev.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nur = inputs.nur.overlays.default;

  nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;
}
