{
  flake.modules.nixos.virtualisation =
    {
      config,
      lib,
      pkgs,
      userName,
      ...
    }:
    let
      cfg = config.tnix.virtualisation;
    in
    {
      options.tnix.virtualisation.qemu = {
        enable = lib.mkEnableOption "QEMU/KVM virtualization with libvirtd";
      };

      config = lib.mkIf cfg.qemu.enable {
        virtualisation = {
          libvirtd = {
            enable = true;
            qemu = {
              swtpm.enable = true;
            };
          };
          spiceUSBRedirection.enable = true;
        };

        users.users.${userName}.extraGroups = [ "libvirtd" ];

        environment.systemPackages = with pkgs; [
          virt-manager
          virt-viewer
        ];
      };
    };

}
