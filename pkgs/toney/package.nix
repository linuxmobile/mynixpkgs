{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "toney";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "SourcewareLab";
    repo = "Toney";
    tag = "v${version}";
    hash = "sha256-y2j/WselGVLMVUcYfzCJeOySwo1o6W5flhdJvx/F2qk=";
  };

  vendorHash = "sha256-Ri9s9JZOAXFxw7/ffPitlfk/O7ccfv/t80QIwMbe/mE=";

  doCheck = false;

  meta = {
    description = "Toney is a fast, lightweight, terminal-based note-taking app for the modern developer.";
    homepage = "https://github.com/SourcewareLab/Toney";
    changelog = "https://github.com/SourcewareLab/Toney/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "toney";
  };
}
