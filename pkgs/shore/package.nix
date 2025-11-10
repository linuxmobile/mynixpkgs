{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shore";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "MoonKraken";
    repo = "shore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sf0000Z/LKOXfnA0PB3LRbPHYoA+FJV4frYU+BpC6WI=";
  };

  cargoHash = "sha256-+o81111Pe9zwiDBUMllpF+my7gp3iLX0+DntFtN7PoI=";

  nativeBuildInputs = [pkg-config];

  meta = {
    description = "CLI-based frontend for inference providers with vim inspired keybindings";
    homepage = "https://github.com/MoonKraken/shore";
    changelog = "https://github.com/MoonKraken/shore/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "shore";
  };
})
