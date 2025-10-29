{
  pkgs,
  inputs,
  username,
  config,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl

    ../common
    ../../modules/nixos/virtualisation/docker.nix
  ];

  hardware.nvidia-container-toolkit = {
    enable = true;
    suppressNvidiaDriverAssertion = true;
  };

  tux.services.openssh.enable = true;

  sops.secrets = {
    hyperbolic_api_key = {
      sopsFile = ./secrets.yaml;
      owner = "${username}";
    };

    gemini_api_key = {
      sopsFile = ./secrets.yaml;
      owner = "${username}";
    };

    open_router_api_key = {
      sopsFile = ./secrets.yaml;
      owner = "${username}";
    };
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  nixpkgs = {
    config.cudaSupport = true;
    hostPlatform = "x86_64-linux";
  };

  wsl = {
    enable = true;
    defaultUser = "${username}";
    useWindowsDriver = true;
  };

  networking.hostName = "sirius";

  programs = {
    ssh.startAgent = true;
    zsh.enable = true;

    nix-ld = {
      enable = true;
      libraries = config.hardware.graphics.extraPackages;
      package = pkgs.nix-ld-rs;
    };

    dconf.enable = true;
  };

  environment.persistence."/persist" = {
    enable = false;
  };

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "23.11";
}
