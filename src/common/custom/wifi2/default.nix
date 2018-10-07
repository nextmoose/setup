{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "wifi2";
  src = ./src;
  buildInputs = [ pkgs.networkmanager ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed -e "s#NETWORKMANAGER#${pkgs.networkmanager}/bin#" -e "w$out/bin/wifi2" wifi2.sh &&
      chmod 0555 $out/bin/wifi2
  '';
}