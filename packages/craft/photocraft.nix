{
  callPackage,
  fetchFromGitHub,
}: let
  # The interface translations, at the commit pinned in the repo's craft-i18n.rev.
  craft-i18n = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-i18n";
    rev = "e02939ef009218e81c44e8ec001fbb7603461de4";
    hash = "sha256-t42doZzXT2sip6CbtekGU287fRyPU1hP+0BqXpwbuIw=";
  };
in
  callPackage ./mk-craft-app.nix {} rec {
    pname = "photocraft";
    version = "0.23.1";
    hash = "sha256-EhyYkRRQBvVX6CbSJX8gk4UOi/zHlE/jgC8wYUfm0ew=";
    cargoHash = "sha256-1L3JH41lUlbGF+Jq+XKb9t32EfvTdSpgd0GkkVPMg5E=";
    releaseDate = "2026-11-12";
    description = "Layered photo editor with PSD support, a clean-room Photoshop reimplementation in Rust";
    homepage = "https://getartcraft.com/apps/photocraft";
    heifFeatures = ["heif"];
    docs = [
      "ATTRIBUTION.md"
      "docs/mcp.md"
      "docs/control-protocol.md"
    ];
    extraEnv = {
      CRAFT_I18N_DIR = toString craft-i18n;
      CRAFT_I18N_REQUIRED = "1";
      PHOTOCRAFT_BUILD_DATE = releaseDate;
    };
  }
