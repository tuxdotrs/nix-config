{ config, ... }:
{
  flake.modules.nixOnDroid.vega =
    {
      pkgs,
      userEmail,
      ...
    }:
    {
      imports = with config.flake.modules.nixOnDroid; [
        networking
      ];

      # @TODO: Broken currently
      # android-integration.am.enable = true;
      # android-integration.termux-open-url.enable = true;
      # android-integration.xdg-open.enable = true;
      # android-integration.termux-setup-storage.enable = true;
      # android-integration.termux-reload-settings.enable = true;

      terminal.font =
        let
          firacode = pkgs.nerd-fonts.fira-code;
          fontPath = "share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFont-Regular.ttf";
        in
        "${firacode}/${fontPath}";

      time.timeZone = "Asia/Kolkata";

      tnix.networking.openssh = {
        enable = true;
        ports = [ 8033 ];
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+OzPUe2ECPC929DqpkM39tl/vdNAXfsRnmrGfR+X3D ${userEmail}"
        ];
      };

      user = {
        uid = 10481;
        gid = 10481;
        shell = "${pkgs.zsh}/bin/zsh";
      };

      environment.etcBackupExtension = ".backup";
      environment.motd = "";
      environment.packages = with pkgs; [
        openssh
        rsync
      ];

      system.stateVersion = "24.05";
    };
}
