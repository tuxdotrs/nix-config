{
  flake.modules.nixos.boot =
    { pkgs, ... }:
    {
      boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelPackages = pkgs.linuxPackages_zen;
      };
    };
}
