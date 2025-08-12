{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "dgop";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${version}";
    hash = "sha256-aqrS+ajzPDDXh9ohKFFuNgZ3mZn9XKptznWwS9gw4tY=";
  };

  vendorHash = "sha256-+5rN3ekzExcnFdxK2xqOzgYiUzxbJtODHGd4HVq6hqk=";

  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 $GOPATH/bin/cli $out/bin/cli
    ln -s $out/bin/cli $out/bin/dgop
    runHook postInstall
  '';

  meta = {
    description = "System monitoring tool with CLI and REST API.";
    homepage = "https://github.com/AvengeMedia/dgop";
    changelog = "https://github.com/AvengeMedia/dgop/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "dgop";
  };
}
