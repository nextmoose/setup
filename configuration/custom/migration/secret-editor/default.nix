{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "secret-editor";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp secret-editor.sh $out/bin/myshell &&
	chmod 0555 $out/bin/secret-editor
  '';
}