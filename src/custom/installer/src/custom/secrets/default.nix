{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "pass";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
	-e "w$out/bin/pass" \
	pass.sh &&
      chmod 0500 $out/bin/installer &&
      mkdir $out/etc &&
      true
  '';
}