{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  squashfsTools,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "helium-widevine";
  version = "${finalAttrs.lacrosVersion}-${builtins.substring 0 7 finalAttrs.widevineInstaller.rev}";
  lacrosVersion = "120.0.6098.0";

  widevineInstaller = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "widevine-installer";
    rev = "7a3928fe1342fb07d96f61c2b094e3287588958b";
    sha256 = "sha256-XI1y4pVNpXS+jqFs0KyVMrxcULOJ5rADsgvwfLF6e0Y=";
  };

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/chromeos-lacros-arm64-squash-zstd-${finalAttrs.lacrosVersion}";
    hash = "sha256-OKV8w5da9oZ1oSGbADVPCIkP9Y0MVLaQ3PXS3ZBLFXY=";
  };

  nativeBuildInputs = [
    squashfsTools
    python3
  ];

  unpackPhase = ''
    unsquashfs -q $src 'WidevineCdm/*'
    python3 $widevineInstaller/widevine_fixup.py squashfs-root/WidevineCdm/_platform_specific/cros_arm64/libwidevinecdm.so libwidevinecdm.so
    cp squashfs-root/WidevineCdm/manifest.json .
    cp squashfs-root/WidevineCdm/LICENSE LICENSE.txt
  '';

  # Accoring to widevine-installer: "Hack because Chromium hardcodes a check for this right now..."
  postInstall = ''
    mkdir -p                      "$out/share/helium/WidevineCdm/_platform_specific/linux_x64"
    touch                         "$out/share/helium/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"
    install -vD manifest.json     "$out/share/helium/WidevineCdm/manifest.json"
    install -vD LICENSE.txt       "$out/share/helium/WidevineCdm/License.txt"
    install -vD libwidevinecdm.so "$out/share/helium/WidevineCdm/_platform_specific/linux_arm64/libwidevinecdm.so"
  '';

  meta = import ./widevine-meta.nix lib;
})
