{
  stdenvNoCC,
  fetchurl,
  lib,
  makeWrapper,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  ffmpeg,
  glib,
  gtk3,
  libdrm,
  libudev0-shim,
  libxkbcommon,
  libgbm,
  nspr,
  nss,
  pango,
  libX11,
  libXcomposite,
  libxcb,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
}: let
  id = "373278730";
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "multiviewer-for-f1";
    version = "2.7.1";

    src = fetchurl {
      url = "https://releases.multiviewer.app/download/${id}/multiviewer_${finalAttrs.version}_amd64.deb";
      hash = "sha256-BKXw8a4fUT+B7KBc6p/Heo+sAtWAG5b/D2iohuNOotY=";
    };

    nativeBuildInputs = [
      dpkg
      makeWrapper
      autoPatchelfHook
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      cairo
      cups
      dbus
      expat
      ffmpeg
      glib
      gtk3
      libdrm
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      libX11
      libXcomposite
      libxcb
      libXdamage
      libXext
      libXfixes
      libXrandr
    ];

    dontBuild = true;
    dontConfigure = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg --fsys-tarfile $src | tar --extract
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share
      mv -t $out/share usr/share/* usr/lib/multiviewer
      makeWrapper "$out/share/multiviewer/multiviewer" $out/bin/multiviewer \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libudev0-shim]}:\"$out/share/multiviewer\""
      runHook postInstall
    '';

    meta = {
      description = "Unofficial desktop client for F1 TV";
      homepage = "https://multiviewer.app";
      downloadPage = "https://multiviewer.app/download";
      changelog = "https://multiviewer.app/changelog";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "multiviewer";
    };
  })
