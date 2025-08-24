{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  pciutils,
}:
buildGoModule rec {
  pname = "dgop";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${version}";
    hash = "sha256-TIeTDwDIH6g974NCX2K0Vmzxb0ZPnPo5CdYcEgvyYJw=";
  };

  vendorHash = "sha256-+3o/Kg5ROSgp8IZfvU71JvbEgaiLasx5IAkjq27faLQ=";

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
