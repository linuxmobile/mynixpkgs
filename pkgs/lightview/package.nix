{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cairo,
  gdk-pixbuf,
  glib,
  graphene,
  gst_all_1,
  gtk4,
  pango,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lightview";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ltdt-apex";
    repo = "lightview";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZSL/4K4KlMcatORL9eqsd9l2gxx8hUsjalhvQvF/F7M=";
  };

  cargoHash = "sha256-N/PdnUdwcu5PwD0Io/avb9/6T+fkKJ6uhUIAG9r6DIg=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    graphene
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk4
    pango
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "lightview";
      exec = "lightview %F";
      icon = "image-x-generic";
      desktopName = "Lightview";
      comment = "Blazing-fast, minimalist image viewer";
      categories = ["Graphics" "Viewer"];
      mimeTypes = [
        "image/jpeg"
        "image/jpg"
        "image/png"
        "image/gif"
        "image/webp"
        "image/bmp"
        "image/tiff"
        "image/svg+xml"
        "image/x-tga"
        "image/x-icon"
        "image/vnd.microsoft.icon"
      ];
      terminal = false;
      startupNotify = true;
    })
  ];

  meta = {
    description = "Blazing-fast, minimalist image viewer built with Rust";
    homepage = "https://github.com/ltdt-apex/lightview";
    changelog = "https://github.com/ltdt-apex/lightview/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "lightview";
  };
})
