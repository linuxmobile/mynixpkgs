{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  qt6,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libdrm,
  libkrb5,
  libuuid,
  libxkbcommon,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  snappy,
  udev,
  wayland,
  xdg-utils,
  coreutils,
  libxcb,
  zlib,
  commandLineArgs ? "",
  pulseSupport ? true,
  libpulseaudio,
  libGL,
  libvaSupport ? true,
  libva,
  enableVideoAcceleration ? libvaSupport,
  vulkanSupport ? false,
  addDriverRunpath,
  enableVulkan ? vulkanSupport,
}: let
  pname = "brave-origin";
  version = "1.91.66";

  src = fetchurl {
    url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-origin-nightly_${version}_amd64.deb";
    hash = "";
  };

  inherit
    (lib)
    optional
    optionals
    makeLibraryPath
    makeSearchPathOutput
    makeBinPath
    optionalString
    strings
    escapeShellArg
    ;

  deps =
    [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      gtk4
      libdrm
      libx11
      libGL
      libxkbcommon
      libxscrnsaver
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxshmfence
      libxtst
      libuuid
      libgbm
      nspr
      nss
      pango
      pipewire
      udev
      wayland
      libxcb
      zlib
      snappy
      libkrb5
      qt6.qtbase
    ]
    ++ optional pulseSupport libpulseaudio
    ++ optional libvaSupport libva;

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  enableFeatures =
    optionals enableVideoAcceleration [
      "AcceleratedVideoDecodeLinuxGL"
      "AcceleratedVideoEncoder"
    ]
    ++ optional enableVulkan "Vulkan";

  disableFeatures =
    [
      "OutdatedBuildDetector"
    ]
    ++ optionals enableVideoAcceleration ["UseChromeOSDirectVideoDecoder"];
in
  stdenv.mkDerivation {
    inherit pname version src;

    dontConfigure = true;
    dontBuild = true;
    dontPatchELF = true;

    nativeBuildInputs = [
      dpkg
      (buildPackages.wrapGAppsHook3.override {makeWrapper = buildPackages.makeShellWrapper;})
    ];

    buildInputs = [
      glib
      gsettings-desktop-schemas
      gtk3
      gtk4
      adwaita-icon-theme
    ];

    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar xf - --no-same-permissions --no-same-owner
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out $out/bin

      cp -R usr/share $out
      cp -R opt/ $out/opt

      export BINARYWRAPPER=$out/opt/brave.com/brave-origin-nightly/brave-origin-nightly

      # Fix path to bash in wrapper script
      substituteInPlace $BINARYWRAPPER \
          --replace-fail /bin/bash ${stdenv.shell} \
          --replace-fail 'CHROME_WRAPPER' 'WRAPPER'

      ln -sf $BINARYWRAPPER $out/bin/brave-origin

      for exe in $out/opt/brave.com/brave-origin-nightly/{brave,chrome_crashpad_handler}; do
          patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath "${rpath}" $exe
      done

      # Fix paths in desktop files
      substituteInPlace $out/share/applications/{brave-origin-nightly,com.brave.Origin.nightly}.desktop \
          --replace-fail /usr/bin/brave-origin-nightly $out/bin/brave-origin
      substituteInPlace $out/share/gnome-control-center/default-apps/brave-origin-nightly.xml \
          --replace-fail /opt/brave.com $out/opt/brave.com
      substituteInPlace $out/opt/brave.com/brave-origin-nightly/default-app-block \
          --replace-fail /opt/brave.com $out/opt/brave.com

      # Set up icons
      icon_sizes=("16" "24" "32" "48" "64" "128" "256")

      for icon in ''${icon_sizes[*]}
      do
          mkdir -p $out/share/icons/hicolor/$icon\x$icon/apps
          ln -s $out/opt/brave.com/brave-origin-nightly/product_logo_$icon.png $out/share/icons/hicolor/$icon\x$icon/apps/brave-origin-nightly.png
      done

      # Replace xdg-settings and xdg-mime
      ln -sf ${xdg-utils}/bin/xdg-settings $out/opt/brave.com/brave-origin-nightly/xdg-settings
      ln -sf ${xdg-utils}/bin/xdg-mime $out/opt/brave.com/brave-origin-nightly/xdg-mime

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : ${rpath}
        --prefix PATH : ${binpath}
        --suffix PATH : ${lib.makeBinPath [xdg-utils coreutils]}
        --set CHROME_WRAPPER ${pname}
        ${optionalString (enableFeatures != []) ''
        --add-flags "--enable-features=${strings.concatStringsSep "," enableFeatures}\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+,WaylandWindowDecorations --enable-wayland-ime=true}}"
      ''}
        ${optionalString (disableFeatures != []) ''
        --add-flags "--disable-features=${strings.concatStringsSep "," disableFeatures}"
      ''}
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
        ${optionalString vulkanSupport ''
        --prefix XDG_DATA_DIRS  : "${addDriverRunpath.driverLink}/share"
      ''}
        --add-flags ${escapeShellArg commandLineArgs}
      )
    '';

    meta = {
      homepage = "https://brave.com/";
      description = "Brave Origin - lightweight privacy browser with Shields";
      license = lib.licenses.mpl20;
      platforms = ["x86_64-linux"];
      mainProgram = "brave-origin";
    };
  }
