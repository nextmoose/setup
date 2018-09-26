{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "secrets";
  src = ./src;
  buildInputs = [ pkgs.gnupg ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed -e "s#OUT#$out#" -e "s#GNUPG#{pkgs.gnupg}#" -e "w$out/bin/secrets" secrets.sh &&
      chmod 0555 $out/bin/secrets &&
      mkdir $out/etc &&
      cp -r secrets $out/etc
  '';
}