{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "secrets";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      cp secrets.sh $out/bin/secrets &&
      chmod 0555 $out/bin/secrets
  '';
}