{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "nekot";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "BalanceBalls";
    repo = "nekot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2H2P7K9V5F+fPZwyuqM1LeoeYPNuSeRWRVNy5yD3Uq0=";
  };

  vendorHash = "sha256-4xNYdzG2KHyRtdcwa36FS6vZG5SazkBLaJSxyYfOgCI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  doCheck = false;

  meta = {
    description = "Powerful and intuitive terminal utility for interacting with both local and cloud LLMs";
    homepage = "https://github.com/BalanceBalls/nekot";
    changelog = "https://github.com/BalanceBalls/nekot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "nekot";
  };
})
