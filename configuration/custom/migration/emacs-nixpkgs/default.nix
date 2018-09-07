{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "emacs-nixpkgs";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp emacs-nixpkgs.sh $out/bin/emacs-nixpkgs &&
	chmod 0555 $out/bin/emacs-nixpkgs
  '';
}