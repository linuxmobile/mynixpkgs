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
  xorg,
}: let
  id = "305607196";
in
  stdenvNoCC.mkDerivation rec {
    pname = "multiviewer-for-f1";
    version = "2.3.0";

    src = fetchurl {
      url = "https://releases.multiviewer.dev/download/${id}/multiviewer_${version}_amd64.deb";
      sha256 = "sha256-Uc4db2o4XBV9eRNugxS6pA9Z5YhjY5QnEkwOICXmUwc=";
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
      xorg.libX11
      xorg.libXcomposite
      xorg.libxcb
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
    ];

    dontBuild = true;
    dontConfigure = true;

    unpackPhase = ''
      runHook preUnpack

      # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
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

    meta = with lib; {
      description = "Unofficial desktop client for F1 TV";
      homepage = "https://multiviewer.app";
      downloadPage = "https://multiviewer.app/download";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "multiviewer";
    };
  }
