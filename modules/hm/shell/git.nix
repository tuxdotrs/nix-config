{
  flake.modules.homeManager.shell =
    {
      userName,
      userEmail,
      ...
    }:
    {
      programs.git = {
        enable = true;
        signing = {
          key = "~/.ssh/id_ed25519.pub";
          signByDefault = true;
        };
        lfs.enable = true;
        settings = {
          user = {
            name = "${userName}";
            email = "${userEmail}";
          };
          init.defaultBranch = "main";
          commit.gpgSign = true;
          gpg.format = "ssh";
        };
      };
    };
}
