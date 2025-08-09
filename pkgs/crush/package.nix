{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "crush";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${version}";
    hash = "sha256-pd1fqM5TwHgLM4IAaGuJDtfKDziJ3x4RUAHYL4oa7jA=";
  };

  vendorHash = "sha256-PeorgBPtQsPUEpwReSsZqjIidkjfl4pyTg2iO0qcDAY=";

  doCheck = false;

  meta = {
    description = "The AI coding agent for your favourite terminal.";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "crush";
  };
}
