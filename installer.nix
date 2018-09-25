{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "installer";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      mkdir $out/etc/nixos &&
      echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" &&
      ls -lah . &&
      echo AAAAA &&
      cp configuration.nix $out/etc/nixos/configuration.nix &&
      echo BBBBB &&
      chmod 0400 $out/etc/nixos/configuration.nix &&
      cp -r custom $out/etc/nixos &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
	-e "w$out/bin/installer" \
	installer.sh &&
      chmod 0500 $out/bin/installer
  '';
}