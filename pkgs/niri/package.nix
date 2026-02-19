{
  lib,
  dbus,
  eudev,
  fetchFromGitHub,
  installShellFiles,
  libdisplay-info,
  libglvnd,
  libinput,
  libxkbcommon,
  libgbm,
  versionCheckHook,
  nix-update-script,
  pango,
  pipewire,
  pkg-config,
  rustPlatform,
  seatd,
  stdenv,
  systemd,
  wayland,
  withDbus ? true,
  withDinit ? false,
  withScreencastSupport ? true,
  withSystemd ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "niri";
  version = "25.11-unstable-2026-02-19";

  src = fetchFromGitHub {
    owner = "niri-wm";
    repo = "niri";
    rev = "3d1cf38bf3ba9bd0208a6452bc4453ad4df79fe2";
    hash = "sha256-mxterEpNc6oDI1oY4+OdWXiLTpSrKBLWKWhAW503GFc=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    patchShebangs resources/niri-session
    substituteInPlace resources/niri.service \
      --replace-fail 'ExecStart=niri' "ExecStart=$out/bin/niri"
    substituteInPlace resources/niri-session \
      --replace-fail 'exec niri' "exec $out/bin/niri"
  '';

  cargoHash = "sha256-uo4AWT4nGV56iiSLhXK30goI7HCPc7AUZjRLgUvLfUE=";

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      libdisplay-info
      libglvnd # For libEGL
      libinput
      libxkbcommon
      libgbm
      pango
      seatd
      wayland # For libwayland-client
    ]
    ++ lib.optional (withDbus || withScreencastSupport || withSystemd) dbus
    ++ lib.optional withScreencastSupport pipewire
    ++ lib.optional withSystemd systemd # Includes libudev
    ++ lib.optional (!withSystemd) eudev; # Use an alternative libudev implementation when building w/o systemd

  buildFeatures =
    lib.optional withDbus "dbus"
    ++ lib.optional withDinit "dinit"
    ++ lib.optional withScreencastSupport "xdp-gnome-screencast"
    ++ lib.optional withSystemd "systemd";
  buildNoDefaultFeatures = true;

  postInstall =
    ''
      install -Dm0644 README.md resources/default-config.kdl -t $doc/share/doc/niri
      mv docs/wiki $doc/share/doc/niri/wiki

      install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
    ''
    + lib.optionalString withDbus ''
      install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
    ''
    + lib.optionalString (withSystemd || withDinit) ''
      install -Dm0755 resources/niri-session -t $out/bin
    ''
    + lib.optionalString withSystemd ''
      install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
    ''
    + lib.optionalString withDinit ''
      install -Dm0644 resources/dinit/niri{-shutdown,} -t $out/lib/dinit.d/user
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd $pname \
        --bash <($out/bin/niri completions bash) \
        --fish <($out/bin/niri completions fish) \
        --zsh <($out/bin/niri completions zsh)
    '';

  env = {
    # Force linking with libEGL and libwayland-client
    # so they can be discovered by `dlopen()`
    RUSTFLAGS = toString (
      map (arg: "-C link-arg=" + arg) [
        "-Wl,--push-state,--no-as-needed"
        "-lEGL"
        "-lwayland-client"
        "-Wl,--pop-state"
      ]
    );

    # Upstream recommends setting the commit hash manually when in a
    # build environment where the Git repository is unavailable.
    # See https://github.com/niri-wm/niri/wiki/Packaging-niri#version-string
    NIRI_BUILD_COMMIT = "Nixpkgs";
  };

  checkFlags = ["--skip=::egl"];
  nativeInstallCheckInputs = [versionCheckHook];
  preVersionCheck = ''
    version=25.11
  '';
  doInstallCheck = true;

  passthru = {
    providedSessions = ["niri"];
    updateScript = nix-update-script {};
  };

  meta = {
    description = "Scrollable-tiling Wayland compositor";
    homepage = "https://github.com/niri-wm/niri";
    changelog = "https://github.com/niri-wm/niri/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "niri";
    platforms = lib.platforms.linux;
  };
})
