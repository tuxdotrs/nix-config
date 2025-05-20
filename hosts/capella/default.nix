{
  pkgs,
  username,
  outputs,
  inputs,
  email,
  ...
}: {
  imports = [
    ../../modules/droid/sshd.nix
  ];

  android-integration.am.enable = true;
  android-integration.termux-open-url.enable = true;
  android-integration.xdg-open.enable = true;
  android-integration.termux-setup-storage.enable = true;
  android-integration.termux-reload-settings.enable = true;

  terminal.font = let
    firacode = pkgs.nerd-fonts.fira-code;
    fontPath = "share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFont-Regular.ttf";
  in "${firacode}/${fontPath}";

  time.timeZone = "Asia/Kolkata";

  tux.services.openssh = {
    enable = true;
    ports = [8033];
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+OzPUe2ECPC929DqpkM39tl/vdNAXfsRnmrGfR+X3D ${email}"
    ];
  };

  user = {
    uid = 10479;
    gid = 10479;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  environment.etcBackupExtension = ".backup";
  environment.motd = '''';
  environment.packages = with pkgs; [
    nano
    git
    neovim
    openssh
    inputs.trok.packages."aarch64-linux".default
  ];

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs username email;};
    useGlobalPkgs = true;
  };

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "24.05";
}
