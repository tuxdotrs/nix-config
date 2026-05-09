{ inputs, ... }:
{
  flake.modules.nixos.boot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.tnix.boot;
    in
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      options.tnix.boot.secure-boot = {
        enable = lib.mkEnableOption "Enable secure-boot";
      };

      config = lib.mkIf cfg.secure-boot.enable {
        assertions = [
          {
            assertion = !cfg.legacy.enable;
            message = "secure-boot and legacy boot (GRUB) cannot be enabled at the same time";
          }
        ];

        environment.systemPackages = [ pkgs.sbctl ];

        # Lanzaboote replaces systemd-boot, so force it off
        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = {
          enable = true;
          autoGenerateKeys.enable = true;
          autoEnrollKeys.enable = true;

          configurationLimit = 10;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };
}
