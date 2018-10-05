{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}

    echo hello
  '';
in
dockerTools.buildImage {
  name = "boot-it";
}