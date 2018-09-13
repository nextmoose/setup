{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "browser";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed \
        -e "s#pkgs.git#${pkgs.git}#" \
	-e "w$out/bin/browser" \
	browser.sh &&
      chmod 0555 $out/bin/browser
  '';
}