{
  stdenv,
  lib,
  bash-completion,
  pkg-config,
  meson,
  mesonEmulatorHook,
  ninja,
  fetchFromGitLab,
  fetchpatch,
  libgudev,
  glib,
  polkit,
  dbus,
  gobject-introspection,
  wrapGAppsNoGuiHook,
  gettext,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  libxml2,
  libxslt,
  upower,
  umockdev,
  systemd,
  python3,
  nixosTests,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "power-profiles-daemon";
  version = "0.30";

  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "power-profiles-daemon";
    rev = finalAttrs.version;
    hash = "sha256-iQUhA46BEln8pyIBxM/MY7An8BzfiFjxZdR/tUIj4S4=";
  };

  patches = [
    (fetchpatch {
      name = "scx-loader-mode-switching.patch";
      url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/power-profiles-daemon/0001-Add-support-for-scx_loader-modes-switching.patch";
      hash = "sha256-cJlC28rSA98f+K2pPW0WBKF+rANOqg8xImv3aYhDv3g=";
    })
  ];

  nativeBuildInputs =
    [
      pkg-config
      meson
      ninja
      gettext
      gtk-doc
      docbook-xsl-nons
      docbook_xml_dtd_412
      libxml2
      libxslt
      gobject-introspection
      wrapGAppsNoGuiHook
      (python3.pythonOnBuildForHost.withPackages (
        ps:
          with ps; [
            pygobject3
            dbus-python
            python-dbusmock
            argparse-manpage
            shtab
          ]
      ))
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs = [
    bash-completion
    libgudev
    systemd
    upower
    glib
    polkit
    (python3.withPackages (ps: [
      ps.pygobject3
    ]))
  ];

  strictDeps = true;

  checkInputs = [
    umockdev
  ];

  nativeCheckInputs = [
    umockdev
    dbus
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=true"
    "-Dpylint=disabled"
    "-Dzshcomp=${placeholder "out"}/share/zsh/site-functions"
    "-Dtests=${lib.boolToString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)}"
  ];

  doCheck = true;

  dontWrapGApps = true;

  env.PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  postPatch = ''
    patchShebangs --build \
      tests/integration-test.py \
      tests/unittest_inspector.py

    patchShebangs --host \
      src/powerprofilesctl
  '';

  postFixup = ''
    wrapGApp "$out/bin/powerprofilesctl"
  '';

  passthru = {
    updateScript = nix-update-script {};
    tests = {
      nixos = nixosTests.power-profiles-daemon;
    };
  };

  meta = {
    changelog = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/releases/${finalAttrs.version}";
    homepage = "https://gitlab.freedesktop.org/upower/power-profiles-daemon";
    description = "Makes user-selected power profiles handling available over D-Bus";
    mainProgram = "powerprofilesctl";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mvnetbiz
      picnoir
      lyndeno
    ];
  };
})
