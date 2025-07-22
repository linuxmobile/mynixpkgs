{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "omm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "omm";
    tag = "v${version}";
    hash = "sha256-sXfFnYntJP4ZEP11R0wxMxN/HbEbGawGX++uPwj60fw=";
  };

  vendorHash = "sha256-8WVKkypYre3w9Dg9Q0IT/XQl1W0PB1Q+VpNxbSWYyJs=";

  doCheck = false;

  meta = {
    description = "on-my-mind: a keyboard-driven task manager for the command line";
    homepage = "https://github.com/dhth/omm";
    changelog = "https://github.com/dhth/omm/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "omm";
  };
}
