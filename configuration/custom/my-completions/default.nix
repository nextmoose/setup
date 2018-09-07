{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-completions";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp my-completions.sh $out/bin/my-completions &&
	chmod 0555 $out/bin/my-completions
  '';
}