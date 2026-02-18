{
  description = "A series of nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  }: let
    eachSystem = fn:
      nixpkgs.lib.genAttrs
      (import systems)
      (system: fn nixpkgs.legacyPackages.${system});

    pkgsDir = builtins.readDir ./pkgs;
    dirs = builtins.filter (
      name:
        pkgsDir.${name}
        == "directory"
        && builtins.hasAttr "package.nix" (builtins.readDir (./pkgs/${name}))
    ) (builtins.attrNames pkgsDir);
  in {
    packages =
      eachSystem (pkgs:
        pkgs.lib.genAttrs dirs (name: pkgs.callPackage (./pkgs/${name}/package.nix) {}));

    formatter = eachSystem (pkgs: pkgs.alejandra);

    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = [pkgs.alejandra pkgs.git];
      };
    });
  };

  nixConfig = {
    extra-substituters = ["https://linuxmobile.cachix.org"];
    extra-trusted-public-keys = ["linuxmobile.cachix.org-1:2K7KEjzbd3U+qMQRte/DGqttosw8EGgGVvu8vKu8D6A="];
  };
}
