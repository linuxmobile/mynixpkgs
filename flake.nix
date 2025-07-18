{
  description = "A series of nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    pkgsDir = builtins.readDir ./pkgs;
    dirs = builtins.filter (
      name:
        pkgsDir.${name}
        == "directory"
        && builtins.hasAttr "package.nix" (builtins.readDir (./pkgs/${name}))
    ) (builtins.attrNames pkgsDir);
  in
    builtins.trace dirs (
      inputs.flake-parts.lib.mkFlake {inherit inputs;} {
        systems = ["x86_64-linux" "aarch64-linux"];
        imports = [];

        perSystem = {pkgs, ...}: {
          packages = pkgs.lib.genAttrs dirs (name: pkgs.callPackage (./pkgs/${name}/package.nix) {});
          formatter = pkgs.alejandra;
          checks = {
            glow-build = pkgs.runCommand "glow-build-test" {} ''
              ${pkgs.glow}/bin/glow --version > $out
            '';
          };
        };
      }
    );

  nixConfig = {
    allowInsecure = true;
    extra-substituters = ["https://linuxmobile.cachix.org"];
    extra-trusted-public-keys = ["linuxmobile.cachix.org-1:2K7KEjzbd3U+qMQRte/DGqttosw8EGgGVvu8vKu8D6A="];
  };
}
