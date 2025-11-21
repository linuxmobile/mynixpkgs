{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "nekot";
  version = "0.6.0-unstable-2025-11-21";

  src = fetchFromGitHub {
    owner = "BalanceBalls";
    repo = "nekot";
    rev = "bcf01952f79aa502c0b26351a97a10b874286b84";
    hash = "sha256-Q9hIbcEJWmRLYi+1rt+8CldXnnG0tae9FQAOUl4++FY=";
  };

  vendorHash = "sha256-ey+lWmMoK8JS9PoOJWuVX6R0OqWrL4DU1Vihr6JXbOM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  doCheck = false;

  meta = {
    description = "Powerful and intuitive terminal utility for interacting with both local and cloud LLMs";
    homepage = "https://github.com/BalanceBalls/nekot";
    changelog = "https://github.com/BalanceBalls/nekot/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "nekot";
  };
}
