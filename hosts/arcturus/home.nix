{username, ...}: {
  home.persistence."/persist/home/${username}" = {
    directories = [
      "Projects"
      "Stuff"
      ".ssh"
      ".local/share/zsh"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
