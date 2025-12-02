{
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  autoPatchelfHook,
  cairo,
  callPackage,
  copyDesktopItems,
  cups,
  fetchurl,
  gcc-unwrapped,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  lib,
  libGL,
  makeWrapper,
  mesa,
  nspr,
  nss,
  pango,
  stdenv,
  systemd,
  wayland,
  dbus,
  libxkbcommon,
  libdrm,
  libgbm,
  xorg,
}: let
  helium-widevine = callPackage ./widevine-x86_64-linux.nix {};
in
  stdenv.mkDerivation rec {
    pname = "helium-browser";
    version = "0.6.7.1";

    src = fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
      hash = "sha256-VB218vOY/9tI97Yhx2MNlNPb46jJHv/FqY96tJaokBE=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      gcc-unwrapped.lib
      glib
      gsettings-desktop-schemas
      gtk3
      libGL
      libdrm
      libgbm
      libxkbcommon
      mesa
      nspr
      nss
      pango
      systemd
      wayland
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
    ];

    autoPatchelfIgnoreMissingDeps = [
      "libQt5Core.so.5"
      "libQt5Gui.so.5"
      "libQt5Widgets.so.5"
      "libQt6Core.so.6"
      "libQt6Gui.so.6"
      "libQt6Widgets.so.6"
    ];

    unpackPhase = ''
      runHook preUnpack
      tar xf $src
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/helium $out/bin

      cp -r helium-${version}-x86_64_linux/* $out/opt/helium/
      chmod +x $out/opt/helium/chrome-wrapper $out/opt/helium/chrome

      cp -r ${helium-widevine}/share/helium/WidevineCdm $out/opt/helium/

      makeWrapper $out/opt/helium/chrome-wrapper $out/bin/helium-browser \
        --chdir $out/opt/helium \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        libGL
        mesa
        libxkbcommon
        dbus
        libgbm
        libdrm
        wayland
      ]}"

      install -Dm644 helium-${version}-x86_64_linux/product_logo_256.png \
        $out/share/icons/hicolor/256x256/apps/helium.png

      install -Dm644 helium-${version}-x86_64_linux/helium.desktop \
        $out/share/applications/helium.desktop

      substituteInPlace $out/share/applications/helium.desktop \
        --replace-fail 'Exec=chromium' "Exec=$out/bin/helium-browser"

      runHook postInstall
    '';

    runtimeDependencies = [
      libGL
      mesa
    ];

    meta = {
      homepage = "https://helium.computer";
      description = "Private, fast, and honest web browser based on Chromium";
      platforms = ["x86_64-linux"];
      mainProgram = "helium-browser";
    };
  }
