{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-install";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      cp my-install.sh $out/bin/my-install &&
      chmod 0500 $out/bin/my-install
  '';
}