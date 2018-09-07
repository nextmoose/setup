{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "pre-push";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp pre-push.sh $out/bin/myshell &&
	chmod 0555 $out/bin/pre-push
  '';
}