{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "browserpass";
  src = fetchzip {
    url = "https://github.com/browserpass/browserpass/releases/download/2.0.22/browserpass-linux64.zip";
    sha256 = "0m0d6x1jhccks43h9qw3rgpvl5l7rb4crmfr4jf1ws7r29ibjbm2";
    stripRoot = false;
  };
  installPhase = ''
    mkdir $out &&
    	  cp -r . $out &&
	  cd $out &&
	  sh ./install.sh chromium
  '';
}