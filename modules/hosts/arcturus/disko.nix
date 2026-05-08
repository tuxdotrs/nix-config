{ inputs, ... }:
{
  flake.modules.nixos.arcturus =
    { config, lib, ... }:
    let
      hasOptinPersistence = config.tnix.boot.impermanence.enable;
    in
    {
      imports = [
        inputs.disko.nixosModules.disko
      ];

      disko.devices.disk.primary = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            root = {
              size = "100%";
              type = "8300";
              content = {
                type = "btrfs";
                # Base subvolumes that always exist
                subvolumes = {
                  "/root" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                    ];
                    mountpoint = "/";
                  };
                  "/nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "noacl"
                      "space_cache=v2"
                    ];
                    mountpoint = "/nix";
                  };
                }
                # Conditionally merge /persist only when impermanence is enabled
                // lib.optionalAttrs hasOptinPersistence {
                  "/persist" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                    ];
                    mountpoint = "/persist";
                  };
                };
              };
            };
          };
        };
      };
    };
}
