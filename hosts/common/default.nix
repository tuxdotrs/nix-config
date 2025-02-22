{
  username,
  outputs,
  inputs,
  email,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager

    ../../modules/base
    ../../modules/nixos/fail2ban.nix
    ../../modules/nixos/sops.nix
    ../../modules/nixos/upstream-proxy.nix
    ../../modules/nixos/tfolio.nix
    ../../modules/nixos/cyber-tux.nix
    ../../modules/nixos/networking/ssh.nix
  ];

  sops.secrets.tux-password = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  programs = {
    zsh.enable = true;
  };

  home-manager = {
    backupFileExtension = "hm-backup";
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs username email;};
    users.${username} = {
      imports = [
        ./home.nix
      ];
    };
  };
}
