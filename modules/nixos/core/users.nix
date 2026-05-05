{
  flake.modules.nixos.core =
    {
      pkgs,
      userName,
      userEmail,
      ...
    }:
    {
      programs.zsh.enable = true;

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
