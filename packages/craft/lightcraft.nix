{callPackage}:
callPackage ./mk-craft-app.nix {} {
  pname = "lightcraft";
  version = "0.21.1";
  hash = "sha256-2iqJCmah1bEVCxQ1VeiPWuhuHcR6U6gj6BYYUu4EcsY=";
  cargoHash = "sha256-TU5eFCjfZrpUTn9r/z5EOG5axvVMz5drG8be1GHjTMI=";
  releaseDate = "2026-11-12";
  description = "Photo library and non-destructive raw developer, a clean-room Lightroom reimplementation in Rust";
  homepage = "https://getartcraft.com/apps/lightcraft";
  heifFeatures = [
    "lightcraft/heif"
    "lightcraft-cli/heif"
  ];
  docs = [
    "assets/ATTRIBUTION.md"
    "assets/fonts/OFL-Inter.txt"
  ];
}
