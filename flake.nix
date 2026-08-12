{
  description = "tux's nix configurations";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tnvim = {
      url = "github:tuxdotrs/tnvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tpanel = {
      url = "github:tuxdotrs/tpanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cyber-tux = {
      url = "git+ssh://git@github.com/tuxdotrs/cyber-tux.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm-flake = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cardwire = {
      url = "github:opengamingcollective/cardwire";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      # @TODO: upstream module is broken for nixpkgs-unstable
      # url = "github:nix-community/nix-on-droid/release-24.05";
      url = "github:newAM/nix-on-droid/update-proot";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11-small";
    impermanence.url = "github:nix-community/impermanence";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix.url = "github:Mic92/sops-nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    lan-mouse.url = "github:feschber/lan-mouse";
    hyprland.url = "github:hyprwm/Hyprland";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    nixcord.url = "github:kaylorben/nixcord";
    nur.url = "github:nix-community/nur";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.1.0";
    copyparty.url = "github:9001/copyparty";
  };
}
