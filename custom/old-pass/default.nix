{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "old-pass";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed -e "s#OUT#$out#" -e "w$out/bin/old-pass" old-pass.sh &&
      chmod 0555 $out/bin/old-pass &&
      cp post-commit.sh w$out/bin/post-commit &&
      chmod 0555 $out/bin/post-commit &&
      true
  '';
}