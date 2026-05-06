{
  flake.modules.nixos.core =
    {
      pkgs,
      lib,
      userName,
      userEmail,
      ...
    }:
    {
      programs.zsh.enable = true;

      time.timeZone = "Asia/Kolkata";
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = lib.genAttrs [
          "LC_ADDRESS"
          "LC_IDENTIFICATION"
          "LC_MEASUREMENT"
          "LC_MONETARY"
          "LC_NAME"
          "LC_NUMERIC"
          "LC_PAPER"
          "LC_TELEPHONE"
          "LC_TIME"
        ] (_: "en_IN");
      };

      users = {
        mutableUsers = false;
        defaultUserShell = pkgs.zsh;
        users.${userName} = {
          initialPassword = userName;
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
            "storage"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+OzPUe2ECPC929DqpkM39tl/vdNAXfsRnmrGfR+X3D ${userEmail}"
          ];
        };
      };
    };
}
