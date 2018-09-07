{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "post-commit";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp main.sh $out/bin/post-commit &&
	chmod 0555 $out/bin/post-commit
  '';
}