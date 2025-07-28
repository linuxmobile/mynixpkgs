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
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "nick42d";
    repo = "youtui";
    tag = "youtui/v${finalAttrs.version}";
    hash = "sha256-hxoRrt0A2JoZdjxoh69b7F3i0+m0GOlggcpihlj4LOY=";
  };

  cargoHash = "sha256-sXu6Db1kgNQN5QUdwjKEpypML6DFG/oU/mazxdZFM7Y=";

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
