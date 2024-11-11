{ pkgs ? import <nixpkgs> {
    config = {
    };
  },
}:


with pkgs; [
  flutter                  # Flutter SDK for building the frontend
  pkg-config               # For package configuration
  jdk17                    # Java Development Kit, needed for Android
  gtk3                     # GTK3, used by Flutter on Linux and macOS
  xorg.libX11              # Required for Flutter on Linux systems
  glib                     # Library required by various components
  dbus                     # Required for interprocess communication
  pcre2                    # PCRE2 for regex support
  go                       # Go programming language for backend development
]
