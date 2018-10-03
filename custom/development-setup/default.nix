{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "development-setup";
  src = ./src;
  buildInputs = [ pkgs.networkmanager ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      cp development-setup.sh $out/bin/development-setup &&
      chmod 0555 $out/bin/development-setup
  '';
}