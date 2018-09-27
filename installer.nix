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
      cp beta.id_rsa $out/etc/nixos/beta.id_rsa &&
      cp beta.id_dss $out/etc/nixos/beta.id_dss &&
      cp beta.id_ecdsa $out/etc/nixos/beta.id_ecdsa &&
      cp -r custom $out/etc/nixos &&
      cp -r secrets $out/etc/secrets &&
      chmod 0400 $out/etc/nixos/configuration.nix &&
      mkdir $out/bin &&
      sed \
        -e "s#OUT#$out#" \
        -e "s#PKGS.GNUPG#${pkgs.gnupg}/bin#" \
	-e "w$out/bin/installer" \
	installer.sh.template &&
      chmod 0500 $out/bin/installer
  '';
}