{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
let
  image = dockerTools.pullImage {
    imageName = "ubuntu:16.04";
    sha256 = "b9e15a5d1e1a11a69061b1dc2e3641805a2dc54e1338faf7f87f4c2c21ed3e6a";
  };
in dockerTools.buildImage {
  name = "shopsafe";
  fromImage = image;
}