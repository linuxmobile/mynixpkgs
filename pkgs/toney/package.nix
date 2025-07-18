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
    tag = "v${version}";
    hash = "sha256-o9W0HsLWNgwIyZtb55kzMw7hOtt+ueWkz/rxbb+pgJg=";
  };

  vendorHash = "sha256-7I3RIrEc+uz8LQCRe0jXPfKqXojHsksZ7w4M9OLY6hM=";

  doCheck = false;

  meta = {
    description = "Toney is a fast, lightweight, terminal-based note-taking app for the modern developer.";
    homepage = "https://github.com/SourcewareLab/Toney";
    changelog = "https://github.com/SourcewareLab/Toney/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "toney";
  };
}
