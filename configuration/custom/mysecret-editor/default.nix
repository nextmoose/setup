{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mysecreteditor";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp main.sh $out/bin/mysecreteditor &&
	chmod 0555 $out/bin/mysecreteditor
  '';
}