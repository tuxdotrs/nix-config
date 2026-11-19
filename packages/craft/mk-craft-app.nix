# Shared source build for storytold's "*Craft" apps (PhotoCraft, LightCraft, ...).
#
# Each app is a pure-Rust cargo workspace with a GUI binary `<name>` and a headless
# `<name>-cli`, built the way upstream's release/flatpak recipes build them:
#   cargo build --release --locked -p <name> -p <name>-cli --features heif
# with the CJK fonts from storytold/craft-fonts embedded (CRAFT_FONTS_DIR).
#
# Unlike the binary repackaging in mahlquistj/artcraft-flake, this builds from source and puts
# the dlopen()ed libraries on the binaries' RUNPATH instead of LD_LIBRARY_PATH, so they don't
# leak into child processes (xdg-open, the portal, lp, ...).
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  autoAddDriverRunpath,
  desktop-file-utils,
  appstream,
  versionCheckHook,
  wayland,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  vulkan-loader,
  libglvnd,
  dbus,
}: {
  pname,
  version,
  hash,
  cargoHash,
  releaseDate,
  description,
  homepage,
  # Cargo feature list enabling HEIF in both binaries (spelling differs per workspace).
  heifFeatures,
  extraEnv ? {},
  extraInstall ? "",
  # Docs installed next to the licences; missing files are an error.
  docs ? [],
}: let
  appId = "ai.storyteller.${pname}";

  # Pinned to the revision upstream's release workflow uses (craft-fonts-ref in release.yml).
  craft-fonts = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "b076417b5880bd4154bd22f00695b1d28c6bea83";
    hash = "sha256-jZ3VBAJDofB6RvsS7GGV5lLT4xiShIjpz5XHBCD2oUc=";
  };

  # Opened with dlopen() at run time, never linked: winit (wayland/x11/xkbcommon),
  # wgpu (vulkan-loader, libEGL via libglvnd), rfd (libdbus-1 for the portal file chooser).
  runtimeLibs = [
    wayland
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    vulkan-loader
    libglvnd
    dbus
  ];
in
  rustPlatform.buildRustPackage {
    inherit pname version cargoHash;

    src = fetchFromGitHub {
      owner = "storytold";
      repo = pname;
      tag = "v${version}";
      inherit hash;
    };

    # Cargo.toml [patch]es a few egui crates nothing uses (Cargo.lock lists them as
    # [[patch.unused]]). fetchCargoVendor only vendors used crates, so cargo can't find them
    # offline; drop those patch entries. Names are read from Cargo.lock to survive bumps.
    postPatch = ''
      for crate in $(sed -n '/^\[\[patch.unused\]\]/{n;s/^name = "\(.*\)"/\1/p}' Cargo.lock); do
        sed -i "/^$crate = { git = /d" Cargo.toml
      done
    '';

    cargoBuildFlags = [
      "-p"
      pname
      "-p"
      "${pname}-cli"
    ];
    buildFeatures = heifFeatures;

    # Upstream's `cargo test --workspace` is long, partly GPU/corpus-dependent and flaky in
    # parallel (see lightcraft's nix/package.nix); the version check below covers the install.
    doCheck = false;

    strictDeps = true;

    nativeBuildInputs = [
      pkg-config
      autoAddDriverRunpath
      desktop-file-utils
      appstream
    ];

    buildInputs = [
      wayland
      libxkbcommon
      libx11
      libxcb
      libxcursor
      libxi
      libxrandr
    ];

    env =
      {
        CRAFT_FONTS_DIR = toString craft-fonts;
        # A broken font input must fail the build instead of shipping without CJK glyphs.
        CRAFT_FONTS_REQUIRED = "1";
      }
      // extraEnv;

    postInstall = ''
      install -Dm644 packaging/linux/${appId}.desktop $out/share/applications/${appId}.desktop
      install -Dm644 packaging/linux/${appId}.mime.xml $out/share/mime/packages/${appId}.xml
      mkdir -p $out/share/icons
      cp -r assets/app-icon/hicolor $out/share/icons/
      install -d $out/share/metainfo
      substitute packaging/linux/${appId}.metainfo.xml.in \
        $out/share/metainfo/${appId}.metainfo.xml \
        --subst-var-by VERSION ${version} \
        --subst-var-by DATE ${releaseDate}

      doc=$out/share/doc/${pname}
      install -Dm644 -t "$doc" README.md LICENSE-MIT LICENSE-APACHE NOTICE ${lib.escapeShellArgs docs}
      for lic in ${craft-fonts}/fonts/*/OFL.txt; do
        install -Dm644 "$lic" "$doc/OFL-$(basename "$(dirname "$lic")").txt"
      done

      desktop-file-validate $out/share/applications/${appId}.desktop
      XDG_CACHE_HOME=$TMPDIR/.cache appstreamcli validate --no-net \
        $out/share/metainfo/${appId}.metainfo.xml
      ${extraInstall}
    '';

    # After fixupPhase's RUNPATH shrinking, which would drop these (nothing links them).
    postFixup = ''
      for bin in $out/bin/${pname} $out/bin/${pname}-cli; do
        patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} "$bin"
      done
    '';

    nativeInstallCheckInputs = [versionCheckHook];
    doInstallCheck = true;
    versionCheckProgram = "${placeholder "out"}/bin/${pname}-cli";

    passthru = {inherit craft-fonts runtimeLibs;};

    meta = {
      inherit description homepage;
      changelog = "https://github.com/storytold/${pname}/releases/tag/v${version}";
      license = with lib.licenses; [
        mit
        asl20
      ];
      sourceProvenance = [lib.sourceTypes.fromSource];
      mainProgram = pname;
      platforms = lib.platforms.linux;
    };
  }
