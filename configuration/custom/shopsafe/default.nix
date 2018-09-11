{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "shopsafe";
  src = ./src;
  buildInputs = [ pkgs.docker ];
  installPhase = ''
    echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA && 
    ls -lah /var/run/. &&
    mkdir $out &&
      docker image build .
  '';
}