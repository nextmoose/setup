{ stdenv ? import <nixpkgs> {} }:
stdenv.mkDerivation {
  name = "hello-2.1.1";
  src = ./src;
}