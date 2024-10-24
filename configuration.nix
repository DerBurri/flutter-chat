{ pkgs ? import <nixpkgs> {
    config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
    };
  },
  buildToolsVersion ? "30.0.3"
}:

let
  # Define Android SDK
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ buildToolsVersion "28.0.3" ];
    platformVersions = [ "34" "30" "28" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
	cmdLineToolsVersion = "8.0";
  };
  androidSdk = androidComposition.androidsdk;
in
with pkgs; [
  flutter
  androidSdk # The customized SDK that we've made above
  jdk17
  pkg-config
  gtk3
  xorg.libX11
  glib
  dbus
  pcre2
  go
]
