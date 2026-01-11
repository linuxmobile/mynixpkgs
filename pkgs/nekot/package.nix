{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "nekot";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "BalanceBalls";
    repo = "nekot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LGHCLfE2VnAWoJUTvtpn+xMTGn2ZIV06gKZGowoghZw=";
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
