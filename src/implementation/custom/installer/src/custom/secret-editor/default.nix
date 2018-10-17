{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "secret-editor";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      nix-build secret-editor.nix &&
      ${pkgs.docker}/bin/docker load < result &&
      true
  '';
}