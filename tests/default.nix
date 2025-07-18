{
  perSystem = {pkgs, ...}: {
    checks = {
      glow-build = pkgs.runCommand "glow-build-test" {} ''
        ${pkgs.glow}/bin/glow --version > $out
      '';
    };
  };
}
