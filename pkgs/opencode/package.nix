{
  lib,
  stdenvNoCC,
  buildGoModule,
  bun,
  fetchFromGitHub,
  # models-dev is imported directly below, not passed as an argument.
  nix-update-script,
  testers,
  writableTmpDirAsHomeHook,
}: let
  modelsDev = import ../models-dev/packages.nix {
    inherit lib stdenvNoCC bun fetchFromGitHub nix-update-script writableTmpDirAsHomeHook;
  };
  opencode-node-modules-hash = {
    "aarch64-darwin" = "sha256-so+KiAo8C7olbJaCH1rIVxs/tq/g9l5pKPaU8D+Zm28=";
    "aarch64-linux" = "sha256-JNf8g0z6oH2OXJLAmCSP0W4WX+GGyald5DAFOYCBNP0=";
    "x86_64-darwin" = "sha256-jwmH4gEcyRNgeMvYz2SyWRagFkYN1O3ULEQIPPgqhwg=";
    "x86_64-linux" = "sha256-L7RwhE9Ixu00vupyzu9k2TzdmLBGaE0QMiS+QDO+HLQ=";
  };
  bun-target = {
    "aarch64-darwin" = "bun-darwin-arm64";
    "aarch64-linux" = "bun-linux-arm64";
    "x86_64-darwin" = "bun-darwin-x64";
    "x86_64-linux" = "bun-linux-x64";
  };
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "opencode";
    version = "0.3.80";
    src = fetchFromGitHub {
      owner = "sst";
      repo = "opencode";
      tag = "v${finalAttrs.version}";
      hash = "sha256-ao/O70ur/b9/tYXWHoHPOzXnrLKKTOeDOemD7+/gnFk=";
    };

    tui = buildGoModule {
      pname = "opencode-tui";
      inherit (finalAttrs) version;
      src = "${finalAttrs.src}/packages/tui";

      vendorHash = "sha256-g2IhNOIKuBf4G4PioXhFvKIWds9ZiYfiG9vnyXCaz6o=";

      subPackages = ["cmd/opencode"];

      env.CGO_ENABLED = 0;

      ldflags = [
        "-s"
        "-X=main.Version=${finalAttrs.version}"
      ];

      installPhase = ''
        runHook preInstall

        install -Dm755 $GOPATH/bin/opencode $out/bin/tui

        runHook postInstall
      '';
    };

    node_modules = stdenvNoCC.mkDerivation {
      patches = [
        ./add-octokit-rest-dep.patch
      ];
      pname = "opencode-node_modules";
      inherit (finalAttrs) version src;

      impureEnvVars =
        lib.fetchers.proxyImpureEnvVars
        ++ [
          "GIT_PROXY_COMMAND"
          "SOCKS_SERVER"
        ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

         export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

         bun install \
           --filter=opencode \
           --force \
           --frozen-lockfile \
           --no-progress

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/node_modules
        cp -R ./node_modules $out

        runHook postInstall
      '';

      # Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      outputHash = opencode-node-modules-hash.${stdenvNoCC.hostPlatform.system};
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };

    nativeBuildInputs = [
      bun
      modelsDev
    ];

    patches = [
      # Patch `packages/opencode/src/provider/models-macro.ts` to get contents of
      # `api.json` from the file bundled with `bun build`.
      ./local-models-dev.patch
    ];

    configurePhase = ''
      runHook preConfigure

      cp -R ${finalAttrs.node_modules}/node_modules .

      runHook postConfigure
    '';

    env.MODELS_DEV_API_JSON = "${modelsDev}/dist/api.json";

    buildPhase = ''
      runHook preBuild

      bun build \
        --define OPENCODE_VERSION="'${finalAttrs.version}'" \
        --compile \
        --minify \
        --target=${bun-target.${stdenvNoCC.hostPlatform.system}} \
        --outfile=opencode \
        ./packages/opencode/src/index.ts \
        ${finalAttrs.tui}/bin/tui

      runHook postBuild
    '';

    dontStrip = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 opencode $out/bin/opencode

      runHook postInstall
    '';

    passthru = {
      tests.version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "HOME=$(mktemp -d) opencode --version";
        inherit (finalAttrs) version;
      };
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "tui"
          "--subpackage"
          "node_modules"
        ];
      };
    };

    meta = {
      description = "AI coding agent built for the terminal";
      longDescription = ''
        OpenCode is a terminal-based agent that can build anything.
        It combines a TypeScript/JavaScript core with a Go-based TUI
        to provide an interactive AI coding experience.
      '';
      homepage = "https://github.com/sst/opencode";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      mainProgram = "opencode";
    };
  })
