{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cloudflare-speed-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kavehtehrani";
    repo = "cloudflare-speed-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sROTLGNImivnLZDoeuqAxV3MsRPUosQR9EldRtU3zQ0=";
  };

  cargoHash = "sha256-BwL2iUqHn55pem5NkbxKmYdXWQ59Fusgx/FJy/9iAfY=";

  nativeBuildInputs = [pkg-config];

  meta = {
    description = "CLI for internet speed test via Cloudflare";
    homepage = "https://github.com/kavehtehrani/cloudflare-speed-cli";
    changelog = "https://github.com/kavehtehrani/cloudflare-speed-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "cloudflare-speed-cli";
  };
})
