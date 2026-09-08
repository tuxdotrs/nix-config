{
  flake.modules.nixos.vps =
    {
      lib,
      modulesPath,
      system,
      ...
    }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault system;
    };
}
