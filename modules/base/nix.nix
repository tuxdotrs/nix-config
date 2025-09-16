{
  pkgs,
  username,
  ...
}: {
  nix = {
    # @TODO enable when lix is patched
    # package = pkgs.lix;

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };

    channel.enable = false;

    settings = {
      extra-platforms = ["aarch64-linux" "arm-linux"];
      auto-optimise-store = true;
      allowed-users = ["${username}"];
      trusted-users = ["${username}"];
      experimental-features = "nix-command flakes";
      keep-going = true;
      warn-dirty = false;
      http-connections = 50;
    };
  };
}
