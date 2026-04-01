{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "scx-loader";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx-loader";
    rev = "v${version}";
    hash = "sha256-B66+Awt+q3GuriRSFWmGKh6GicQiPlpQMPlpwbItUrk=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [pkg-config];

  postInstall = ''
    install -Dm644 services/org.scx.Loader.service \
      $out/share/dbus-1/system-services/org.scx.Loader.service
    install -Dm644 configs/org.scx.Loader.conf \
      $out/share/dbus-1/system.d/org.scx.Loader.conf
    install -Dm644 configs/org.scx.Loader.xml \
      $out/share/dbus-1/interfaces/org.scx.Loader.xml
    install -Dm644 configs/org.scx.Loader.policy \
      $out/share/polkit-1/actions/org.scx.Loader.policy
    install -Dm644 services/scx_loader.service \
      $out/lib/systemd/system/scx_loader.service
    install -Dm644 configs/scx_loader.toml \
      $out/share/scx_loader/config.toml

    substituteInPlace $out/lib/systemd/system/scx_loader.service \
      --replace-fail "ExecStart=/usr/bin/scx_loader" "ExecStart=$out/bin/scx_loader"

    substituteInPlace $out/share/dbus-1/system-services/org.scx.Loader.service \
      --replace-fail "Exec=/usr/bin/scx_loader" "Exec=$out/bin/scx_loader"
  '';

  meta = {
    description = "D-Bus daemon for on-demand loading and mode-switching of sched_ext schedulers";
    homepage = "https://github.com/sched-ext/scx-loader";
    license = lib.licenses.gpl2Only;
    platforms = ["x86_64-linux"];
    mainProgram = "scx_loader";
  };
}
