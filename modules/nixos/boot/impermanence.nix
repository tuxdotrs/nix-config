{ inputs, ... }:
{
  flake.modules.nixos.boot =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.tnix.boot;
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      options.tnix.boot.impermanence = {
        enable = lib.mkEnableOption "Enable impermanence";
      };

      config = lib.mkIf cfg.impermanence.enable {
        programs.fuse.userAllowOther = true;
        fileSystems."/persist".neededForBoot = true;
        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib"
            "/etc/NetworkManager/system-connections"
          ];
          files = [
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
          ];
        };

        boot.initrd.systemd = {
          enable = true;

          services.wipe-my-fs = {
            wantedBy = [ "initrd.target" ];
            after = [ "initrd-root-device.target" ];
            before = [ "sysroot.mount" ];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = ''
              mkdir /btrfs_tmp
              mount /dev/disk/by-partlabel/disk-primary-root /btrfs_tmp

              if [[ -e /btrfs_tmp/root ]]; then
                  mkdir -p /btrfs_tmp/old_roots
                  timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
                  mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
              fi

              delete_subvolume_recursively() {
                  IFS=$'\n'
                  for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                      delete_subvolume_recursively "/btrfs_tmp/$i"
                  done
                  btrfs subvolume delete "$1"
              }

              for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
                  delete_subvolume_recursively "$i"
              done

              btrfs subvolume create /btrfs_tmp/root
              umount /btrfs_tmp
            '';
          };
        };
      };
    };
}
