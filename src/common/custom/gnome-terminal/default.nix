{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "gnome-terminal";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      pkgs.dockerTools.buildImage {
        name = "gnome-terminal";
      }
  '';
}