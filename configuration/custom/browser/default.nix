{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "browser";
  src = ./src;
  buildInputs = [ pkgs.chromium ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      cp my-browser.sh $out/bin/browser &&
      chmod 0555 $out/bin/browser
  '';
}