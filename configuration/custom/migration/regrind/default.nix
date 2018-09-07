{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "regrind";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp shell.sh $out/bin/regrind &&
	chmod 0555 $out/bin/regrind
  '';
}