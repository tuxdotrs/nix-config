{username, ...}: {
  home.persistence."/persist/home/${username}" = {
    directories = [
      "Projects"
      "Stuff"
      ".ssh"
      ".wakatime"
      ".config/sops"
      ".config/go-wol"
      ".local/share/nvim"
      ".local/share/zsh"
      ".local/share/zoxide"
      ".local/state/lazygit"
    ];
    files = [
      ".wakatime.cfg"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
