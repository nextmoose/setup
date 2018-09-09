{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-browser";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp my-browser.sh $out/bin/my-browser &&
	chmod 0555 $out/bin/my-browser
  '';
}