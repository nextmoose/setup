{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "shopsafe";
  src = ./src;
  buildInputs = [ pkgs.docker ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      cp Dockerfile $out/etc &&
      mkdir $out/bin &&
      sed -e "s#out#$out#" -e "w$out/bin/shopsafe" shopsafe.sh &&
      chmod 0555 $out/bin/shopsafe &&
      mkdir $out/volume
  '';
}