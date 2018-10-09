{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "installer";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      cp installer.sh $out/bin/installer &&
      chmod 0500 $out/bin/installer &&
      mkdir $out/etc &&
      cp configuration.nix $out/etc &&
      chmod 0500 $out/etc/configuration.nix &&
      true
  '';
}