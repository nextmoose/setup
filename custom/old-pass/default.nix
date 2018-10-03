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
      sed \
        -e "s#OUT#$out#" \
	-e "s#GNUPG#${pkgs.gnupg}/bin#" \
	-e "s#PASS#${pkgs.pass}/bin#" \
	-e "w$out/bin/post-commit" \
	post-commit.sh &&
      chmod 0555 $out/bin/post-commit &&
      true
  '';
}