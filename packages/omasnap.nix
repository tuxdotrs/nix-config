{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  hyprland,
  kdePackages,
  ninja,
  pkg-config,
  tesseract,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wl-clipboard,
}:
stdenv.mkDerivation {
  pname = "omasnap";
  version = "v1.20.1";

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "omasnap";
    rev = "d339588f3aba554f314d6233da2dddc98f83de55";
    hash = "sha256-90p1lZDj4cksAAhpbJMQwN6cMqqcZyRVESMLpjmw294=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/share/wayland-protocols" \
        "${wayland-protocols}/share/wayland-protocols"
  '';

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    kdePackages.qtbase
    wayland
    wayland-protocols
  ];

  cmakeFlags = [(lib.cmakeBool "BUILD_TESTING" false)];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      hyprland
      tesseract
      wl-clipboard
    ])
  ];

  meta = {
    description = "Fast Wayland screenshot and annotation overlay for Hyprland";
    homepage = "https://github.com/omacom/omasnap";
    license = lib.licenses.mit;
    mainProgram = "omasnap";
    platforms = lib.platforms.linux;
  };
}
