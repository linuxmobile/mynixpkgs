{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "claude-code-proxy";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nielspeter";
    repo = "claude-code-proxy";
    rev = "v${version}";
    hash = "sha256-sGRQZgj+u0VNJRIDebkTmPgTe0OKS4ApSCsr+mcK6Ig=";
  };

  vendorHash = "sha256-4PX6/ZqCg+qIYDdBVyi4RaPBWwZZhK+vXtzmHVyw32U=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  postInstall = ''
    install -Dm755 scripts/ccp $out/bin/ccp
  '';

  doCheck = false;

  meta = with lib; {
    description = "Lightweight HTTP proxy to use OpenRouter/OpenAI/Ollama with Claude Code";
    longDescription = ''
      A proxy that translates Claude Code API calls to OpenAI-compatible providers
      (OpenRouter, OpenAI Direct, Ollama). Full tool calling, streaming and thinking
      blocks support. Includes a convenient `ccp` wrapper that auto-starts the daemon.
    '';
    homepage = "https://github.com/nielspeter/claude-code-proxy";
    changelog = "https://github.com/nielspeter/claude-code-proxy/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "claude-code-proxy";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
