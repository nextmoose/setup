{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "old-pass";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
	-e "s#GNUPG#${pkgs.gnupg}/bin#" \
	-e "s#PASS#${pkgs.pass}/bin#" \
	-e "w$out/bin/old-pass" \
	old-pass.sh &&
      chmod 0555 $out/bin/old-pass &&
      cp post-commit.sh $out/bin/post-commit &&
      chmod 0555 $out/bin/post-commit &&
      true
  '';
}