{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "my-install";
  src = ./src;
  installPhase = ''
    mkdir $out &&
      mkdir $out/etc &&
      mkdir $out/etc/nixos &&
      cp configuration.nix $out/etc/nixos/configuration.nix &&
      cp -r custom $out/etc/nixos &&
      cp -r secrets $out/etc/secrets &&
      chmod 0400 $out/etc/nixos/configuration.nix &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
	-e "w$out/bin/installer" \
	installer.sh.template &&
      chmod 0500 $out/bin/installer
  '';
}