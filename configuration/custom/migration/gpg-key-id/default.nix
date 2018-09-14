{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
let
  script = pkgs.writeShellScriptBin "gpg-key-id" ''
     ${pkgs.gnupg}/bin/gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":"
  '';
in
stdenv.mkDerivation rec {
  name = "gpg-key-id";
  buildInputs = [ pkgs.gnupg script ];
  src = .;
}