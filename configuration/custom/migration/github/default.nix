{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "github";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp shell.sh $out/bin/github &&
	chmod 0555 $out/bin/github
  '';
}