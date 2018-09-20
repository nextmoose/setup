{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "my-install";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      mkdir $out/etc/nixos &&
      cp configuration.nix $out/etc/nixos &&
      chmod 0400 $out/etc/nixos/configuration.nix &&
      mkdir $out/bin &&
      sed \
        -e "s#XXX#$out#" \
	-e "w$out/bin/my-install" \
	$out/bin/my-install.sh &&
      chmod 0500 $out/bin/my-install
  '';
}