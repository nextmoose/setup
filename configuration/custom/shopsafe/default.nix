{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
let
  image = dockerTools.pullImage {
    imageName = "ubuntu";
    finalImageTag = "16.04";
  };
in dockerTools.buildImage {
  name = "shopsafe";
  fromImage = image;
}