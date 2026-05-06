{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        systemctl-tui
        zip
        unzip
        pciutils
        usbutils
        jq
        dig
        lsof
      ];
    };
}
