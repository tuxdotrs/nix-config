{
  flake.modules.nixos.boot = {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      supportedFilesystems = ["ntfs"];
    };
  };
}
