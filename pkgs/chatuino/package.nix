{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "chatuino";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "julez-dev";
    repo = "chatuino";
    rev = "v${version}";
    hash = "sha256-5F/CWr3mlDjEcmq6fYJaDqIK4rCzLuBYVMvPAWmoH5I=";
  };

  vendorHash = "sha256-XSWHIEiOs2E8Keh0Lk0b99B5nKm3rlNFFyAGbBPrcq0=";

  nativeBuildInputs = [installShellFiles];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  doCheck = false;

  meta = {
    description = "A (hopefully soon) feature rich TUI Twitch IRC Client";
    homepage = "https://github.com/julez-dev/chatuino";
    changelog = "https://github.com/julez-dev/chatuino/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "chatuino";
  };
}
