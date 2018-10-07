{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "secret-editor";
  src = ./src;
  buildInputs = [ pkgs.networkmanager ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed -e "s#NETWORKMANAGER#${pkgs.networkmanager}/bin#" -e "w$out/bin/wifi" wifi.sh &&
      chmod 0555 $out/bin/wifi
  '';
}