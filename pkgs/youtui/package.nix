{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  alsa-lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "youtui";
  version = "0.0.26";

  src = fetchFromGitHub {
    owner = "nick42d";
    repo = "youtui";
    tag = "youtui/v${finalAttrs.version}";
    hash = "sha256-OcAoaIpM6EA2ZrvPEnSzYZrRf7AakwTSEvjMm7g2xfE=";
  };

  cargoHash = "sha256-/ThEvscSrdZDNJxa+aLacg3/jnkQmevdDJngnHoGgaw=";

  nativeBuildInputs = [pkg-config openssl alsa-lib];
  PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [openssl.dev alsa-lib.dev];

  # All test fail without this
  doCheck = false;

  meta = {
    description = "TUI and API for YouTube Music written in Rust ";
    homepage = "https://github.com/nick42d/youtui";
    changelog = "https://github.com/nick42d/youtui/releases/tag/youtui/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "youtui";
  };
})
