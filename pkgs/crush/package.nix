{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "crush";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${version}";
    hash = "sha256-l6X6Hdh0NRGXG9YBYRWkcgJwJwK2II//Z9iQd8wTzcs=";
  };

  vendorHash = "sha256-aI3MSaQYUOLJxBxwCoVg13HpxK46q6ZITrw1osx5tiE=";

  doCheck = false;

  meta = {
    description = "The AI coding agent for your favourite terminal.";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "crush";
  };
}
