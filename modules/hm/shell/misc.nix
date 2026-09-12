{
  flake.modules.homeManager.shell = {pkgs, ...}: {
    home.packages = with pkgs; [
      systemctl-tui
      zip
      unzip
      pciutils
      usbutils
      jq
      dig
      lsof
      trok

      (writeShellScriptBin "hm-override" ''
        #!/usr/bin/env bash

        set -euo pipefail

        usage() {
          echo "Usage:"
          echo "  $0 <filename>              Override symlink"
          echo "  $0 <filename> --restore    Restore symlink"
          echo "  $0 <filename> -r           Restore symlink"
          exit 1
        }

        if [[ $# -lt 1 || $# -gt 2 ]]; then
          usage
        fi

        FILE="$1"
        LINK_BACKUP="''${FILE}.backup-link"

        # Restore
        if [[ "''${2:-}" == "--restore" || "''${2:-}" == "-r" ]]; then
          if [[ ! -f "$LINK_BACKUP" ]]; then
            echo "Error: no backup symlink found: $LINK_BACKUP"
            exit 1
          fi

          TARGET="$(cat "$LINK_BACKUP")"

          # Remove the temporary override.
          rm -f "$FILE"

          # Restore the original symlink.
          ln -s "$TARGET" "$FILE"

          # Remove the temporary symlink target backup.
          rm "$LINK_BACKUP"

          echo "Restored: $FILE -> $TARGET"
          exit 0
        fi

        # Override mode
        if [[ ! -L "$FILE" ]]; then
          echo "Error: $FILE is not a symlink"
          exit 1
        fi

        if [[ -e "$LINK_BACKUP" ]]; then
          echo "Error: backup already exists: $LINK_BACKUP"
          echo "Restore the existing override before running again."
          exit 1
        fi

        # Remember the original symlink target.
        TARGET="$(readlink "$FILE")"
        printf '%s\n' "$TARGET" > "$LINK_BACKUP"

        # Copy the contents before removing the symlink.
        cp "$FILE" "$FILE.tmp"

        # Replace the symlink with a regular writable file.
        rm "$FILE"
        mv "$FILE.tmp" "$FILE"

        chmod u+w "$FILE"

        echo "Overridden: $FILE"
        echo "Original:   $FILE -> $TARGET"
      '')
    ];
  };
}
