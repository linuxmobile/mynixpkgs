{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  gcc13Stdenv ? stdenv,
}:
gcc13Stdenv.mkDerivation rec {
  pname = "dawn";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "andrewmd5";
    repo = "dawn";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-W7cqR2dw5DFTdW9Br1wNZuHasFgla/+AzERJ24y+YPw=";
  };

  nativeBuildInputs = [cmake];

  buildInputs = [curl];

  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release"];

  installPhase = ''
    runHook preInstall
    install -Dm755 dawn $out/bin/dawn
    runHook postInstall
  '';

  meta = with lib; {
    description = "A distraction-free terminal-based markdown editor with live rendering";
    longDescription = ''
      Dawn is a lightweight document drafter that runs in your terminal.
      It renders markdown as you type, supports math (Unicode), syntax highlighting,
      tables, footnotes, and more. No Electron or browser required.
    '';
    homepage = "https://github.com/andrewmd5/dawn";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "dawn";
  };
}
