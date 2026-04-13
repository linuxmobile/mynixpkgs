{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  glib,
  gtk4,
  wrapGAppsHook4,
  libadwaita,
  gst_all_1,
  desktop-file-utils,
  pipewire,
  libv4l,
  libcamera,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gdk-pixbuf,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "camoverlay";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "didley";
    repo = "camoverlay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JWSnJie0Tz4C6Rw+oUvkVpotSCLWO1p+nvKl64V85zo=";
  };

  cargoHash = "sha256-7NoQ7bHZICGkzlKu9fwMM7oJkb+LNFsre/wwKjgDM2Y=";

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    glib
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-libav
    pipewire
    libv4l
    libcamera
    adwaita-icon-theme
    gsettings-desktop-schemas
    gdk-pixbuf
  ];

  postPatch = ''
    patchShebangs build-aux/cargo.sh

    rm .cargo/config.toml

    substituteInPlace src/window.rs \
      --replace-fail '.field("framerate", gstreamer::Fraction::new(30, 1))' "" \
      --replace-fail 'src.link(&capsfilter).expect("Failed to link src→capsfilter");' \
                     'let src_conv = gstreamer::ElementFactory::make("videoconvert").build().expect("Failed to create src_conv");
                      pipeline.add(&src_conv).expect("Failed to add src_conv");
                      src.link(&src_conv).expect("Failed to link src→src_conv");
                      src_conv.link(&capsfilter).expect("Failed to link src_conv→capsfilter");'
  '';

  configurePhase = ''
    runHook preConfigure
    meson setup build --prefix=$out -Dbuildtype=release
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ninja -C build -v
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ninja -C build install
    runHook postInstall
  '';

  meta = {
    description = "GNOME app that displays a webcam preview as a borderless overlay, for use during screen recording";
    homepage = "https://github.com/didley/camoverlay";
    changelog = "https://github.com/didley/camoverlay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "camoverlay";
    platforms = lib.platforms.linux;
  };
})
