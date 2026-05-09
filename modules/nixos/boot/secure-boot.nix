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
        environment.systemPackages = [
          pkgs.sbctl
        ];

        # Lanzaboote currently replaces the systemd-boot module.
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
