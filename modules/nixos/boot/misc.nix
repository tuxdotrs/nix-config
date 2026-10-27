{
  flake.modules.nixos.boot = {
    boot = {
      consoleLogLevel = 0;
      supportedFilesystems = ["ntfs"];
    };
  };
}
