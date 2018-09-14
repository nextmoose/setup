{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  script = pkgs.writeShellScriptBin "browser" ''
    ${pkgs.chromium} --disable-gpu
  '';
stdenv.mkDerivation rec {
  name = "browser";
  buildInputs = [ script ];
}