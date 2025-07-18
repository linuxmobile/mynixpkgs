{
  pkgs,
  ...
}:
  pkgs.runCommand "glow-basic-test" {} ''
    ${pkgs.glow}/bin/glow --help > $out
  ''
