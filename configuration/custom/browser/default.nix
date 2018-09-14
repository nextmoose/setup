{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
let
  script = pkgs.writeShellScriptBin "browser" ''
    ${pkgs.chromium} --disable-gpu
  '';
stdenv.mkDerivation {
  name = "browser";
  buildInputs = [ script ];
}