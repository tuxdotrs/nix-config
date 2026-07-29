{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs.gpu-screen-recorder = {
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        gpu-screen-recorder-gtk
      ];
    };
}
