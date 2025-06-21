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
    ../../modules/home/barrier
    ../../modules/home/firefox
    ../../modules/home/brave
    ../../modules/home/vs-code
    ../../modules/home/mopidy
    ../../modules/home/thunderbird
    ../../modules/home/easyeffects
    ../../modules/home/discord
    ../../modules/home/kdeconnect
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };

  qt.enable = true;
  qt.platformTheme.name = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

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
  };

  home.packages = with pkgs; [
    telegram-desktop
    anydesk
    stable.rustdesk-flutter
    rawtherapee
    stable.beekeeper-studio
    obs-studio
    libreoffice-qt
    spotify
    stremio
    galaxy-buds-client
    copyq
    vlc
    tor-browser
    distrobox
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
      ".config/BraveSoftware"
      ".config/copyq"
      ".config/discord"
      ".config/Vencord"
      ".config/vesktop"
      ".config/sops"
      ".config/obs-studio"
      ".config/rustdesk"
      ".config/spotify"
      ".local/share/nvim"
      ".local/share/zsh"
      ".local/share/zoxide"
      ".local/share/Smart\ Code\ ltd"
      ".local/share/GalaxyBudsClient"
      ".local/share/TelegramDesktop"
      ".local/state/lazygit"
      ".cache/spotify"
    ];
    files = [
      ".wakatime.cfg"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
