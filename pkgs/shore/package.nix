{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shore";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "MoonKraken";
    repo = "shore";
    tag = "${finalAttrs.version}";
    hash = "sha256-K9GKMijLU1ii5O8P4fT5Vl3S3HoVmvcUyCiIC69dTdU=";
  };

  cargoHash = "sha256-HYdTODIHA1TGhu6BKrKFkvBlGtqVt89wYX9Ehn0EOC0=";

  nativeBuildInputs = [pkg-config openssl];
  PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [openssl.dev];
  # All test fail without this
  doCheck = false;

  meta = {
    description = "CLI-based frontend for inference providers with vim inspired keybindings";
    homepage = "https://github.com/MoonKraken/shore";
    changelog = "https://github.com/MoonKraken/shore/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "shore";
  };
})
