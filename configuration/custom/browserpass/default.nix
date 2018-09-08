{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "browserpass";
  src = fetchzip {
    url = "https://github.com/browserpass/browserpass/releases/download/2.0.22/browserpass-linux64.zip";
    sha256 = "0ikz6m801gfmgzd4q0la5pcivl46yiviad5gvz0qba0pa7wc8g0g";
  };
  installPhase = ''
  mkdir $out &&
  	mkdir $out/bin &&
	cp github.sh $out/bin/github &&
	chmod 0555 $out/bin/github
  '';
}