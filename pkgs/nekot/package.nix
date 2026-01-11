{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "nekot";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "BalanceBalls";
    repo = "nekot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yk6yhy/reFddIHUT1x07VCzHiPfEOKdvAVkhwUOJ3qM=";
  };

  vendorHash = "sha256-oor12No/R+d/yqzY4BquChaYtPnHRE9ZZNIJdQylohk=";

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
