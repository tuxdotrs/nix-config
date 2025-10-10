{pkgs, ...}: {
  imports = [
    ./lazygit.nix
    ./superfile.nix
    ./open-code.nix
  ];

  programs = {
    bat.enable = true;
    zsh = {
      enable = true;
      history = {
        append = true;
        share = true;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        size = 1000000;
        save = 1000000;
        path = "$HOME/.local/share/zsh/.zsh_history";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      initContent = ''
        fastfetch
        export WINIT_X11_SCALE_FACTOR=1
        PATH=$PATH:~/.cargo/bin:~/.local/bin

        bindkey "^A" vi-beginning-of-line
        bindkey "^E" vi-end-of-line
        bindkey '^R' fzf-history-widget
      '';
    };
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
      enableZshIntegration = true;
    };
    ripgrep.enable = true;
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        update_ms = 1000;
        presets = "cpu:0:default mem:0:default net:0:default";
      };
    };
    go.enable = true;
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    lsd = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.packages = with pkgs; [
    systemctl-tui
    ranger
    wget
    portal
    bore-cli
    zip
    unzip
    pciutils
    gnumake
    nvtopPackages.full
    zellij
    nix-output-monitor
    duf
    jq
    atac
    termshark
    solc
    dig

    python312
    python312Packages.pipx
    nodejs
    nodePackages.pnpm
    nodePackages.yarn
    rustup
    bun
    nixpkgs-fmt

    hunspell
    hunspellDicts.en_US
    air
    templ
    ffmpeg
    deploy-rs
    trok
  ];
}
