{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dfft";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "dfft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5JCGTrleCeJQ+pLiMyncLjm+m++lLCRxTmPRbAhgSOs=";
  };

  cargoHash = "sha256-mBvUzqXrpQyeZcIKhmA6v5rIoXIHTSG0sqisZwRTniw=";

  nativeBuildInputs = [pkg-config alsa-lib];

  PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [alsa-lib.dev];

  meta = {
    description = "Monitor changes as AI agents modify your codebase.";
    homepage = "https://github.com/dhth/dfft";
    changelog = "https://github.com/dhth/dfft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "dfft";
  };
})
