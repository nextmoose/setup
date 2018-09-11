{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "shopsafe";
  src = ./src;
  installPhase = ''
    pkgs.dockerTools.buildImage {
      name="hello";
      tag="001";
      fromImage="alpine:3.4";
    };
  '';
}