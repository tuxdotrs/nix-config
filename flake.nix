{
  description = "tux's Nix Flake";

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (inputs.nixpkgs.lib) nixosSystem;
    inherit (inputs.nix-on-droid.lib) nixOnDroidConfiguration;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    username = "tux";
    email = "t@tux.rs";

    mkNixOSConfig = host: {
      specialArgs = {inherit inputs outputs username email;};
      modules = [./hosts/${host}];
    };

    mkDroidConfig = host: {
      pkgs = import nixpkgs {system = "aarch64-linux";};
      extraSpecialArgs = {inherit inputs outputs username email;};
      modules = [./hosts/${host}];
    };

    mkNixOSNode = hostname: {
      inherit hostname;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${hostname};
      };
    };

    activateNixOnDroid = configuration:
      deploy-rs.lib.aarch64-linux.activate.custom
      configuration.activationPackage
      "${configuration.activationPackage}/activate";

    mkDroidNode = hostname: {
      inherit hostname;
      profiles.system = {
        sshUser = "nix-on-droid";
        user = "nix-on-droid";
        magicRollback = true;
        sshOpts = ["-p" "8033"];
        path = activateNixOnDroid self.nixOnDroidConfigurations.${hostname};
      };
    };
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # 'nixos-rebuild switch --flake .#your-hostname'
    nixosConfigurations = {
      arcturus = nixosSystem (mkNixOSConfig "arcturus");
      canopus = nixosSystem (mkNixOSConfig "canopus");
      alpha = nixosSystem (mkNixOSConfig "alpha");
      sirius = nixosSystem (mkNixOSConfig "sirius");
      vega = nixosSystem (mkNixOSConfig "vega");
      node = nixosSystem (mkNixOSConfig "node");
      vps = nixosSystem (mkNixOSConfig "vps");
      isoImage = nixosSystem (mkNixOSConfig "isoImage");
      homelab = nixosSystem (mkNixOSConfig "homelab");
    };

    # NixOnDroid configuration entrypoint
    # 'nix-on-droid switch --flake .#your-hostname'
    nixOnDroidConfigurations = {
      capella = nixOnDroidConfiguration (mkDroidConfig "capella");
      rigel = nixOnDroidConfiguration (mkDroidConfig "rigel");
    };

    deploy = {
      nodes = {
        arcturus = mkNixOSNode "arcturus";
        canopus = mkNixOSNode "canopus";
        alpha = mkNixOSNode "alpha";
        sirius = mkNixOSNode "sirius";
        vega = mkNixOSNode "vega";
        node = mkNixOSNode "node";
        homelab = mkNixOSNode "homelab";
        capella = mkDroidNode "capella";
        rigel = mkDroidNode "rigel";
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm-flake = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/tuxdotrs/nix-secrets.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    tawm = {
      url = "github:tuxdotrs/tawm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tnvim = {
      url = "github:tuxdotrs/tnvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trok = {
      url = "github:tuxdotrs/trok";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tpanel = {
      url = "github:tuxdotrs/tpanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tfolio = {
      url = "git+ssh://git@github.com/tuxdotrs/tfolio.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cyber-tux = {
      url = "git+ssh://git@github.com/tuxdotrs/cyber-tux.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awww.url = "git+https://codeberg.org/LGFae/awww";
    ghostty.url = "github:ghostty-org/ghostty";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    nur.url = "github:nix-community/nur";
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixcord.url = "github:kaylorben/nixcord";
    lan-mouse.url = "github:feschber/lan-mouse";
  };
}
