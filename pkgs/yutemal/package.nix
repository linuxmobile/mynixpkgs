{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  openssl,
  alsa-lib,
}:
buildGoModule rec {
  pname = "yutemal";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "haryoiro";
    repo = "yutemal";
    tag = "v${version}";
    hash = "sha256-PfvIQFkkWtxly+iONQsJp+QICyt9q71snjVVfmmj0ZI=";
  };

  vendorHash = "sha256-kOX90w+zDe99BPjp1iK5lJd8OBgDnlZaa8+Jos4n6JA=";

  nativeBuildInputs = [pkg-config openssl alsa-lib];
  PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [openssl.dev alsa-lib.dev];

  doCheck = false;

  meta = {
    description = " A terminal music player for YouTube Music ";
    homepage = "https://github.com/haryoiro/yutemal";
    changelog = "https://github.com/haryoiro/yutemal/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "yutemal";
  };
}
