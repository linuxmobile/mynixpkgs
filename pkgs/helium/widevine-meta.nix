lib: {
  description = "Widevine CDM";
  homepage = "https://www.widevine.com";
  sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  license = lib.licenses.mit;
  platforms = lib.map (name: lib.removeSuffix ".nix" (lib.removePrefix "widevine-" name)) (
    lib.filter (name: name != "meta.nix" && name != "package.nix") (
      builtins.attrNames (builtins.readDir ./.)
    )
  );
}
