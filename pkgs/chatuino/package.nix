{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "chatuino";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "julez-dev";
    repo = "chatuino";
    rev = "v${version}";
    hash = "sha256-e7t9WxpLrNWVY7oddmJozwq5tTLcfx2ii+1oCBRCgvo=";
  };

  vendorHash = "sha256-b86ell9S4bie3p831Z8PRjh45Izr8ukWrYs8bFko/U0=";

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
