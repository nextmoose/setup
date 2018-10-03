{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "development-setup";
  src = ./src;
  buildInputs = [ pkgs.networkmanager ];
  installPhase = ''
    mkdir $out &&
      mkdir $out/bin &&
      sed -e "s#OUT#$out#" -e "w$out/bin/development-setup" development-setup.sh &&
      chmod 0555 $out/bin/development-setup &&
      cp pre-push.sh $out/bin/pre-push &&
      chmod 0555 $out/bin/pre-push &&
      cp post-commit.sh $out/bin/post-commit &&
      chmod 0555 $out/bin/post-commit &&
      true
  '';
}