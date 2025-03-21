{pkgs, ...}: {
  firefox-mod-blur = pkgs.callPackage ./firefox-mod-blur {};
  plymouth-spinner-monochrome = pkgs.callPackage ./plymouth-spinner-monochrome {};
  go-wol = pkgs.callPackage ./go-wol {};
}
