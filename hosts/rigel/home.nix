{pkgs, ...}: {
  imports = [
    ../../modules/home/git
    ../../modules/home/starship
  ];

  programs = {
    bat.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
    zsh = {
      enable = true;
      shellAliases = {
        ls = "lsd";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      initContent = ''
        fastfetch
      '';
    };
  };

  home.packages = with pkgs; [
    neovim
    busybox
    lsd
    fastfetch
  ];

  home.stateVersion = "24.05";
}
