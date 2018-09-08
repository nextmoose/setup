{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "browserpass";
  src = fetchzip {
    url = "https://github.com/browserpass/browserpass/releases/download/2.0.22/browserpass-linux64.zip";
  };
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp github.sh $out/bin/github &&
	chmod 0555 $out/bin/github
  '';
}