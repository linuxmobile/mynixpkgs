{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "prs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "prs";
    tag = "v${version}";
    hash = "sha256-oVG2BMO3vYJQwrDHblM7Wq2PV46hDwtLDq1J9AwFKAk=";
  };

  vendorHash = "sha256-YcbXdgNJ3D2wofye59Vj7mBIgvKBGtKL5o/3QnEooWE=";

  doCheck = false;

  meta = {
    description = "Stay updated on PRs from your terminal";
    homepage = "https://github.com/dhth/prs";
    changelog = "https://github.com/dhth/prs/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "prs";
  };
}
