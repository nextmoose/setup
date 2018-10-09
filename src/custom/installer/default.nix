{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "installer";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
	-e "w$out/bin/installer" \
	installer.sh &&
      chmod 0500 $out/bin/installer &&
      mkdir $out/etc &&
      cp configuration.nix $out/etc &&
      chmod 0500 $out/etc/configuration.nix &&
      cp pass.tar.gpg $out/etc &&
      chmod 0500 $out/etc/pass.tar.gpg &&
      true
  '';
}