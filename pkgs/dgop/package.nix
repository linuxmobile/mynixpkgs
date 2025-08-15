{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "dgop";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${version}";
    hash = "sha256-QCJbcczQjUZ+Xf7tQHckuP9h8SD0C4p0C8SVByIAq/g=";
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
