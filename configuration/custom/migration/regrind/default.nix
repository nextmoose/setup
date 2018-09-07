{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "regrind";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp regrind.sh $out/bin/myshell &&
	chmod 0555 $out/bin/regrind
  '';
}