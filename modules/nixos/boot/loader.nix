{
  flake.modules.nixos.boot =
    { config, lib, ... }:
    let
      cfg = config.tnix.boot;
    in
    {
      options.tnix.boot.legacy = {
        enable = lib.mkEnableOption "legacy boot (GRUB) instead of systemd-boot";
      };

      config = lib.mkMerge [
        {
          boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

          boot.loader = {
            timeout = 1;
            efi.canTouchEfiVariables = true;
          };
        }

        (lib.mkIf (!cfg.legacy.enable && !cfg.secure-boot.enable) {
          boot.loader.systemd-boot.enable = true;
        })

        (lib.mkIf cfg.legacy.enable {
          boot.loader.grub.enable = true;
        })
      ];
    };
}
