{
  flake.modules.nixos.core = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kitty.terminfo
      ghostty.terminfo
      wezterm.terminfo
    ];
  };
}
