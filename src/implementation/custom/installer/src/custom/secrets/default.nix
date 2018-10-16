{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "secrets";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
	-e "w$out/bin/secrets" \
	secrets.sh &&
      chmod 0500 $out/bin/secrets &&
      mkdir $out/etc &&
      cp --recursive secrets $out/etc &&
      true
  '';
}