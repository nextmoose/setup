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
        -e "s#pkgs.gnupg#${pkgs.gnupg}#" \
        -e "s#pkgs.pass#${pkgs.pass}#" \
        -e "s#pkgs.chromium#${pkgs.chromium}#" \
	-e "s#pkgs.gpg-key-id#(import ./custom/migration/gpg-key-id/default.nix { inherit pkgs; })#" \
	-e "w$out/bin/browser" \
	browser.sh &&
      chmod 0555 $out/bin/browser
  '';
}