{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/home/desktop/awesome
    ../../modules/home/desktop/hyprland
    ../../modules/home/picom
    ../../modules/home/alacritty
    ../../modules/home/wezterm
    ../../modules/home/ghostty
    ../../modules/home/desktop/rofi
    ../../modules/home/lan-mouse
    ../../modules/home/firefox
    ../../modules/home/brave
    ../../modules/home/vs-code
    ../../modules/home/zed
    ../../modules/home/mopidy
    ../../modules/home/thunderbird
    ../../modules/home/easyeffects
    ../../modules/home/discord
    ../../modules/home/kdeconnect
    ../../modules/home/obs-studio
    ../../modules/home/spotify
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 28;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-black";
    };
  };

  services.flameshot = {
    enable = true;
    package = pkgs.flameshot.override {enableWlrSupport = true;};
    settings = {
      General = {
        useGrimAdapter = true;
      };
    };
  };

  home.packages = with pkgs; [
    telegram-desktop
    anydesk
    stable.rustdesk-flutter
    rawtherapee
    stable.beekeeper-studio
    libreoffice-qt
    spotify
    # @TODO Enable when qt5 webengine patched
    # https://github.com/NixOS/nixpkgs/blob/b599843bad24621dcaa5ab60dac98f9b0eb1cabe/pkgs/development/libraries/qt-5/modules/qtwebengine.nix#L466
    # stremio
    galaxy-buds-client
    copyq
    vlc
    tor-browser
    distrobox
    bluetui
    impala
  ];

  home.persistence."/persist/home/${username}" = {
    directories = [
      "Downloads"
      "Music"
      "Wallpapers"
      "Documents"
      "Videos"
      "Projects"
      "Stuff"
      "go"
      ".mozilla"
      ".ssh"
      ".wakatime"
      ".rustup"
      ".cargo"
      ".cache/spotify-player"
      ".config/BraveSoftware"
      ".config/copyq"
      ".config/discord"
      ".config/Vencord"
      ".config/vesktop"
      ".config/sops"
      ".config/obs-studio"
      ".config/rustdesk"
      ".config/kdeconnect"
      ".local/share/nvim"
      ".local/share/opencode"
      ".local/share/zsh"
      ".local/share/zoxide"
      ".local/share/Smart\ Code\ ltd"
      ".local/share/GalaxyBudsClient"
      ".local/share/TelegramDesktop"
      ".local/state/lazygit"
    ];
    files = [
      ".wakatime.cfg"
      ".config/aichat/.env"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
