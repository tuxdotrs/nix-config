{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };
    };
}
