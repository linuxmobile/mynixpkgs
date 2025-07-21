{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bmm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "bmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sfAUvvZ/LKOXfnA0PB3LRbPHYoA+FJV4frYU+BpC6WI=";
  };

  cargoHash = "sha256-+o8bYi4Pe9zwiDBUMllpF+my7gp3iLX0+DntFtN7PoI=";

  nativeBuildInputs = [pkg-config];

  meta = {
    description = "Get to your bookmarks in a flash";
    homepage = "https://github.com/dhth/bmm";
    changelog = "https://github.com/dhth/bmm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "bmm";
  };
})
