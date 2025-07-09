{device ? throw "Set this to the disk device, e.g. /dev/nvme0n1", ...}: {
  disko.devices.disk.primary = {
    inherit device;
    type = "disk";
    content = {
      type = "gpt"; # GPT partitioning scheme
      partitions = {
        boot = {
          name = "boot";
          size = "1M";
          type = "EF02";
        };
        # EFI Partition
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["defaults" "umask=0077"];
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
                mountOptions = ["compress=zstd"]; # Compression for better performance
                mountpoint = "/"; # Root subvolume
              };
              "/persist" = {
                mountOptions = ["compress=zstd"]; # Compression for persistent data
                mountpoint = "/persist"; # Persistent subvolume
              };
              "/nix" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                  "noacl"
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
