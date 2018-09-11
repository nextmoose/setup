{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "shopsafe";
  src = ./src;
  buildInputs = [ pkgs.docker ];
  installPhase = ''
    mkdir $out &&
      docker image build .
  '';
}