{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.tux.packages.distrobox;
in {
  options.tux.packages.distrobox = {
    enable = mkEnableOption "Enable DistroBox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox

      (writeShellScriptBin "dbox-create" ''
        #!/usr/bin/env bash

        # 1. Initialize variables
        IMAGE=""
        NAME=""

        # Array to hold optional arguments (like volumes)
        declare -a EXTRA_ARGS

        # 2. Parse arguments
        while [[ $# -gt 0 ]]; do
          case $1 in
            -i|--image)
              IMAGE="$2"
              shift 2
              ;;
            -n|--name)
              NAME="$2"
              shift 2
              ;;
            -p|--profile)
              echo ":: Profile mode enabled: Mounting Nix store and user profiles (Read-Only)"
              # Add volume flags to the array
              EXTRA_ARGS+=( "--volume" "/nix/store:/nix/store:ro" )
              EXTRA_ARGS+=( "--volume" "/etc/profiles/per-user:/etc/profiles/per-user:ro" )
              EXTRA_ARGS+=( "--volume" "/etc/static/profiles/per-user:/etc/static/profiles/per-user:ro" )
              shift 1
              ;;
            *)
              echo "Unknown option $1"
              exit 1
              ;;
          esac
        done

        if [ -z "$IMAGE" ] || [ -z "$NAME" ]; then
            echo "Usage: dbox-create -i <image> -n <name> [-p]"
            exit 1
        fi

        # 3. Define the custom home path
        CUSTOM_HOME="$HOME/Distrobox/$NAME"

        echo "------------------------------------------------"
        echo "Creating Distrobox: $NAME"
        echo "Location: $CUSTOM_HOME"
        echo "------------------------------------------------"

        # 4. Run Distrobox Create
        # We expand "''${EXTRA_ARGS[@]}" to properly pass the volume arguments
        ${pkgs.distrobox}/bin/distrobox create \
          --image "$IMAGE" \
          --name "$NAME" \
          --home "$CUSTOM_HOME" \
          "''${EXTRA_ARGS[@]}"

        # Check exit code
        if [ $? -ne 0 ]; then
            echo "Error: Distrobox creation failed."
            exit 1
        fi

        # 5. Post-Creation: Symlink Config Files
        echo "--> Linking configurations to $NAME..."

        # Helper function to symlink
        link_config() {
            SRC="$1"
            DEST="$2"
            DEST_DIR=$(dirname "$DEST")

            # Create parent directory if it doesn't exist
            mkdir -p "$DEST_DIR"

            if [ -e "$SRC" ]; then
                # ln -sf: symbolic link, force overwrite
                ln -sf "$SRC" "$DEST"
                echo "    [LINK] $DEST -> $SRC"
            else
                echo "    [SKIP] $SRC not found on host"
            fi
        }

        # Create Symlinks
        link_config "$HOME/.zshrc"                "$CUSTOM_HOME/.zshrc"
        link_config "$HOME/.zshenv"               "$CUSTOM_HOME/.zshenv"
        link_config "$HOME/.config/fastfetch"     "$CUSTOM_HOME/.config/fastfetch"
        link_config "$HOME/.config/starship.toml" "$CUSTOM_HOME/.config/starship.toml"

        echo "--> Done! Enter via: distrobox enter $NAME"
      '')
    ];
  };
}
