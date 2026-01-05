{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cloudflare-speed-cli";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "kavehtehrani";
    repo = "cloudflare-speed-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XLyStlbBO8Pl+AZHHv6uafQX0OtRzonqTRx6tJTSJ5M=";
  };

  cargoHash = "sha256-7cIKRInEO0cndbA8pcpMOOfQq/N6ieOWZJGxB8Bys6E=";

  nativeBuildInputs = [pkg-config];

  meta = {
    description = "CLI for internet speed test via Cloudflare";
    homepage = "https://github.com/kavehtehrani/cloudflare-speed-cli";
    changelog = "https://github.com/kavehtehrani/cloudflare-speed-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "cloudflare-speed-cli";
  };
})
