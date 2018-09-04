{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "hello-2.1.1";
  src = ./src;
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp hello.sh $out/bin/hello &&
	chmod 0555 $out/bin/hello
  '';
}