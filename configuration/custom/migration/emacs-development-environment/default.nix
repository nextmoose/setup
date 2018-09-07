{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "emacs-development-environment";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp emacs-development-environment.sh $out/bin/emacs-development-environment &&
	chmod 0555 $out/bin/emacs-development-environment
  '';
}