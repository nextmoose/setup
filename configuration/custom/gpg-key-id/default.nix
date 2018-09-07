{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "gpg-key-id";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp main.sh $out/bin/gpg-key-id &&
	chmod 0555 $out/bin/gpg-key-id
  '';
}