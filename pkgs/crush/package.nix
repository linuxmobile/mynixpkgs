{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "crush";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${version}";
    hash = "sha256-1tSzhRApmt1JBhuCfQnzZr2Dw2HioEtlboe9H2RZGAk=";
  };

  vendorHash = "sha256-8H+uNdrJB0f5XOhRL3avZY3ZIKkI50y4fcVD8S4/8SI=";

  doCheck = false;

  meta = {
    description = "The AI coding agent for your favourite terminal.";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "crush";
  };
}
