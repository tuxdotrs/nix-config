{device ? throw "Set this to the disk device, e.g. /dev/nvme0n1", ...}: {
  disko.devices.disk.primary = {
    inherit device;
    type = "disk";
    content = {
      type = "gpt"; # GPT partitioning scheme
      partitions = {
        # EFI Partition
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
        # Swap Partition
        swap = {
          size = "32G";
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true; # Enable hibernation
          };
        };
        # Btrfs Root Partition
        root = {
          size = "100%"; # Use remaining space
          type = "8300"; # Linux filesystem type
          content = {
            type = "btrfs";
            subvolumes = {
              "/root" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                  "space_cache=v2"
                ]; # Compression for better performance
                mountpoint = "/"; # Root subvolume
              };
              "/persist" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                  "space_cache=v2"
                ]; # Compression for persistent data
                mountpoint = "/persist"; # Persistent subvolume
              };
              "/nix" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                  "noacl"
                  "space_cache=v2"
                ]; # Optimize for Nix store
                mountpoint = "/nix"; # Nix subvolume
              };
            };
          };
        };
      };
    };
  };
}
