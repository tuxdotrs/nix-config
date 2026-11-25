{
  flake.modules.nixos.capella = {
    lib,
    modulesPath,
    system,
    ...
  }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    # boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.kernelParams = ["console=ttyAMA0"];
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault system;
  };
}
