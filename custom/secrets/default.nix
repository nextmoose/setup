{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "secrets";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed -e "s#OUT#$out#" -e "w$out/bin/secrets" secrets.sh &&
      chmod 0555 $out/bin/secrets
  '';
}