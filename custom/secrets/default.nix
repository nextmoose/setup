{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "secrets";
  src = ./src;
  buildInputs = [ pkgs.gnupg ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed -e "s#OUT#$out#" -e "s#GNUPG#${pkgs.gnupg}#" -e "w$out/bin/secrets" secrets.sh &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      cat $out/bin/secrets &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA &&
      chmod 0555 $out/bin/secrets &&
      mkdir $out/etc &&
      cp -r secrets $out/etc
  '';
}