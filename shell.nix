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
  };
  androidSdk = androidComposition.androidsdk;
in
pkgs.mkShell {
  ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  buildInputs = [
    pkgs.flutter
    androidSdk # The customized SDK that we've made above
    pkgs.jdk17
    pkgs.pkg-config
    pkgs.gtk3
    pkgs.xorg.libX11
    pkgs.glib
    pkgs.dbus
    pkgs.pcre2
  ];
}
