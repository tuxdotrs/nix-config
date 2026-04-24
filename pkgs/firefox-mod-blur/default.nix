{
  lib,
  stdenv,
  pkgs,
}:
stdenv.mkDerivation {
  pname = "firefox-mod-blur";
  version = "v2.14";

  src = pkgs.fetchFromGitHub {
    owner = "datguypiko";
    repo = "Firefox-Mod-Blur";
    rev = "refs/heads/master";
    sha256 = "sha256-CkS0Jl30OBZTGAcL1ytoqJ9yzXg8a2JfuJbMw3+Tkj0=";
  };

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
    cp -r "$out/EXTRA MODS/Bookmarks Bar Mods/Bookmarks bar same color as toolbar/bookmarks_bar_same_color_as_toolbar.css" "$out/"
  '';

  meta = with lib; {
    description = "Firefox Mod Blur";
    homepage = "https://github.com/datguypiko/Firefox-Mod-Blur";
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}
