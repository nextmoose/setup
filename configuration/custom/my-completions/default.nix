{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-completions";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/completions &&
	cp completions/*.sh $out/completions &&
	mkdir $out/bin &&
	sh generate.sh $out
  '';
}