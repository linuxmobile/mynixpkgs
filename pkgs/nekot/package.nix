{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "nekot";
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "BalanceBalls";
    repo = "nekot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bWosTrFmGyZbDR7l3Wp3ba3kK4qd9zpfiB46LiuV9mQ=";
  };

  vendorHash = "sha256-ey+lWmMoK8JS9PoOJWuVX6R0OqWrL4DU1Vihr6JXbOM=";

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
