{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "github";
  src = ./src;
  buildInput = [ (import ../gpg-key-id/default.nix { inherit pkgs; }) ];
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	sed \
	  -e "s#pkgs.git#${pkgs.git}#" \
	  -e "s#pkgs.emacs#${pkgs.emacs}#" \
	  -e "s#pkgs.openssh#${pkgs.openssh}#" \
	  -e "s#pkgs.id#${(import ../gpg-key-id/default.nix { inherit pkgs; })}" \
	  -e "w$out/bin/github" \
	  github.sh &&
	chmod 0555 $out/bin/github
  '';
}