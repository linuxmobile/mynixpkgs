{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "crush";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${version}";
    hash = "sha256-P/rHU1SwcU1BjQOBECY1bFiYKsLyizuH85+3/VRjnC0=";
  };

  vendorHash = "sha256-GWramb6YXzajoVNpUQ9mZLE02zWRnvG4hC3EFOA5apU=";

  doCheck = false;

  meta = {
    description = "The AI coding agent for your favourite terminal.";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "crush";
  };
}
