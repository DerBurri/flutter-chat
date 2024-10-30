{ pkgs ? import <nixpkgs> {
    config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
    };
  },
  buildToolsVersion ? "30.0.3"
}:


with pkgs; [
  flutter
  pkg-config
  gtk3
  xorg.libX11
  glib
  dbus
  pcre2
]
