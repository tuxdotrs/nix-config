{...}: {
  home.persistence."/persist" = {
    directories = [
      "Projects"
      ".ssh"
      ".local/share/zsh"
    ];
  };

  home.stateVersion = "24.11";
}
