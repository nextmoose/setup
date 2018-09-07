{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mysecret-editor";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp shell.sh $out/bin/mysecret-editor &&
	chmod 0555 $out/bin/mysecret-editor
  '';
}