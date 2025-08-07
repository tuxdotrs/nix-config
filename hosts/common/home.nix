{
  outputs,
  username,
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-index-database.homeModules.nix-index

    ../../modules/home/shell
    ../../modules/home/git
    ../../modules/home/starship
    ../../modules/home/fastfetch
    ../../modules/home/nvim
    ../../modules/home/tmux
    ../../modules/home/helix
    ../../modules/home/aria2
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.nur
      outputs.overlays.nix-vscode-extensions
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      joypixels.acceptLicense = true;
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
}
