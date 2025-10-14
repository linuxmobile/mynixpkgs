{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  pciutils,
}:
buildGoModule rec {
  pname = "dgop";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${version}";
    hash = "sha256-Lm/6kEqMiP+1X5eno80vANBhLEhFRjRki9LzSfXpvNs=";
  };

  vendorHash = "sha256-2iZwpbTEpxlDEdCbYSdDbW/G+9znxr0cqQky3Uaqnv4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.buildTime=1970-01-01_00:00:00"
    "-X main.Commit=${version}"
  ];

  doCheck = false;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    runHook preInstall
    install -Dm755 $GOPATH/bin/cli $out/bin/dgop
    wrapProgram $out/bin/dgop --prefix PATH : "${lib.makeBinPath [pciutils]}"
    runHook postInstall
  '';

  meta = {
    description = "System monitoring tool with CLI and REST API.";
    homepage = "https://github.com/AvengeMedia/dgop";
    changelog = "https://github.com/AvengeMedia/dgop/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "dgop";
    binaryNativeCode = true;
  };
}
