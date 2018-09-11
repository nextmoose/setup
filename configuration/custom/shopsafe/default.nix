{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
let
  image = dockerTools.pullImage {
    imageName = "ubuntu";
    sha256 = "0na3idj2g4zzg39h0g55wzwy2vpvbblfrw3iw1b1ybaqn6bvs6nz";
  };
in dockerTools.buildImage {
  name = "shopsafe";
  fromImage = image;
}