{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "needle";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "cesarferreira";
    repo = "needle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S3UKCQdTbpMJoHkT4chI/pnT121XBEZ4ff11PTdIF6c=";
  };

  cargoHash = "sha256-Fiphy7xLOQYyW9ggPVF1tgQDVtMjT25Lu8/GuLKHFWs=";

  nativeBuildInputs = [pkg-config];

  meta = {
    description = "TUI that shows the few PRs that need you: review requests, failing CI, and long-running checks.";
    homepage = "https://github.com/cesarferreira/needle";
    changelog = "https://github.com/cesarferreira/needle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "needle";
  };
})
