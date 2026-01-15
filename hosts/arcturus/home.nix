{...}: {
  home.persistence."/persist" = {
    directories = [
      "Projects"
      "Stuff"
      ".ssh"
      ".local/share/zsh"
    ];
  };

  home.stateVersion = "24.11";
}
