{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "toney";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "SourcewareLab";
    repo = "Toney";
    tag = "v${version}";
    hash = "sha256-GIOWQCGqGrZBg+E7lg/doVx/UYQvI68AqEXykW/nYJA=";
  };

  vendorHash = "sha256-0ImF4Ose1PyC6wa4miH/Uy8WQfo7jdRcOnYa6MwaEig=";

  doCheck = false;

  meta = {
    description = "Toney is a fast, lightweight, terminal-based note-taking app for the modern developer.";
    homepage = "https://github.com/SourcewareLab/Toney";
    changelog = "https://github.com/SourcewareLab/Toney/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "toney";
  };
}
