
{ pkgs ? import <nixpkgs> {} }:

let
  webDir = ./build/web; # Replace with the path to your directory
in
pkgs.stdenv.mkDerivation {
  name = "simple-webserver";
  buildInputs = [ pkgs.python3 ];

  buildPhase = ''
    mkdir -p $out/bin
    cp -r ${webDir} $out/web
    cat > $out/bin/webserver <<EOF
    #!/bin/sh
    cd $out/web
    exec python3 -m http.server 8000
EOF
    chmod +x $out/bin/webserver
  ''
  };
}