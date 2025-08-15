{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "crush";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${version}";
    hash = "sha256-QUYNJ2Ifny9Zj9YVQHcH80E2qa4clWVg2T075IEWujM=";
  };

  vendorHash = "sha256-vdzAVVGr7uTW/A/I8TcYW189E3960SCIqatu7Kb60hg=";

  doCheck = false;

  meta = {
    description = "The AI coding agent for your favourite terminal.";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "crush";
  };
}
