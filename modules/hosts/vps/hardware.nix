{
  flake.modules.nixos.vps = {
    pkgs,
    lib,
    modulesPath,
    system,
    ...
  }: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot.kernelPackages = pkgs.linuxPackages_zen;
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault system;
  };
}
