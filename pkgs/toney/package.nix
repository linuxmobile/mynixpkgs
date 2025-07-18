{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "toney";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "SourcewareLab";
    repo = "Toney";
    rev = "v${version}";
    hash = "sha256-lDGCRtwCpW/bZlfcb100g7tMXN2dlCPnCY7qVFyayUo=";
  };

  vendorHash = "sha256-JqQnLwkxRt+CiP90F+1i4MAiOw3akMQ5BeQXCplZdxA=";

  doCheck = false;

  meta = {
    description = "Toney is a fast, lightweight, terminal-based note-taking app for the modern developer.";
    homepage = "https://github.com/SourcewareLab/Toney";
    changelog = "https://github.com/SourcewareLab/Toney/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "toney";
  };
}
