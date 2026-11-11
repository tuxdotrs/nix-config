{
  lib,
  stdenvNoCC,
  fetchurl,
  jq,
  librsvg,
  unzip,
  zip,
  appName ? "Mailer",
  assets ? ./assets,
  # Bump on every branding change: Stalwart only installs a bundle whose
  # stalwart-app.json version is newer than the installed one. Reset to 1
  # when `upstreamVersion` changes.
  brandRevision ? 2,
}: let
  upstreamVersion = "1.21.1";
  # major.minor.(patch * 1000 + revision): newer than every earlier branding
  # revision and still older than the next upstream patch release.
  bundleVersion = let
    v = lib.splitString "." upstreamVersion;
  in "${lib.elemAt v 0}.${lib.elemAt v 1}.${toString (lib.toInt (lib.elemAt v 2) * 1000 + brandRevision)}";
in
  stdenvNoCC.mkDerivation {
    pname = "webmail";
    version = bundleVersion;

    src = fetchurl {
      # Versioned name: a fetchurl store path depends only on name + hash, so with a
      # fixed name a stale hash silently reuses the old zip instead of failing.
      name = "bulwark-lite-stalwart-${upstreamVersion}.zip";
      url = "https://github.com/bulwarkmail/webmail/releases/download/${upstreamVersion}/bulwark-lite-stalwart.zip";
      hash = "sha256-Ej7IPfICgLUdcrEDQSJZ1vp07JiVpJGcCd5g9BiXkQQ=";
    };

    nativeBuildInputs = [
      jq
      librsvg
      unzip
      zip
    ];

    unpackPhase = ''
      runHook preUnpack
      mkdir bundle
      unzip -q $src -d bundle
      runHook postUnpack
    '';

    buildPhase = ''
      runHook preBuild
      cd bundle

      # Logo paths starting with / get Stalwart's mount prefix at runtime.
      mkdir -p branding/mailer
      cp ${assets}/{logo,logo-white,favicon,wordmark,wordmark-white}.svg branding/mailer/

      # Lite has no pwaIconUrl: the install / home-screen icons are these PNGs.
      rsvg-convert -w 180 -h 180 ${assets}/icon.svg -o apple-touch-icon.png
      for s in 192 512; do
        rsvg-convert -w $s -h $s ${assets}/icon.svg -o icon-''${s}x''${s}.png
        rsvg-convert -w $s -h $s ${assets}/icon-maskable-light.svg -o icon-maskable-light-''${s}x''${s}.png
        rsvg-convert -w $s -h $s ${assets}/icon-maskable-dark.svg -o icon-maskable-dark-''${s}x''${s}.png
      done

      jq --arg name ${lib.escapeShellArg appName} '
          ._comment = "\($name) (Bulwark Lite) for Stalwart"
        | .appName = $name
        | .loginCompanyName = $name
        | .faviconUrl = "/branding/mailer/favicon.svg"
        | .appLogoLightUrl = "/branding/mailer/logo.svg"
        | .appLogoDarkUrl = "/branding/mailer/logo.svg"
        | .loginLogoLightUrl = "/branding/mailer/wordmark.svg"
        | .loginLogoDarkUrl = "/branding/mailer/wordmark-white.svg"
        | .loginLogoMaxWidth = "280px"
        | .loginShowHeading = false
      ' config.json > config.json.new
      mv config.json.new config.json

      jq --arg name ${lib.escapeShellArg appName} '
          .name = $name | .short_name = $name
        | .description = "\($name) - Webmail"
        | .theme_color = "#6366F1"
      ' manifest.json > manifest.json.new
      mv manifest.json.new manifest.json

      # Keep id "bulwark-webmail" so Stalwart updates the existing app.
      jq '.version = "${bundleVersion}"' stalwart-app.json > stalwart-app.json.new
      mv stalwart-app.json.new stalwart-app.json

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      find . -exec touch -h -d @1 {} +
      find . -type f | LC_ALL=C sort | zip -q -X -@ $out
      runHook postInstall
    '';

    meta = {
      description = "Bulwark Lite webmail bundle for Stalwart, branded as ${appName}";
      homepage = "https://bulwarkmail.org";
      license = lib.licenses.agpl3Only;
      platforms = lib.platforms.all;
    };
  }
