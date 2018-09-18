{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "install";
  src = ./src;
  buildInputs = [ pkgs.haskellPackages.mount ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      cp install.sh $out/bin/install.sh &&
      chmod 0500 $out/bin/install &&
      mkdir $out/volume
  '';
}