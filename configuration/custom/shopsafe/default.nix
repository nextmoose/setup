{ pkgs ? import <nixpkgs> {} }:

with import <nixpkgs> {};
let
  image = dockerTools.pullImage {
    imageName = "ubuntu";
    imageDigest = "sha256:ce4ea6b8cb8730d6a48b747037d0448b8151ea666d65f58e1b967147b0787734";
    sha256 = "0na3idj2g4zzg39h0g55wzwy2vpvbblfrw3iw1b1ybaqn6bvs6nz";
    finalImageTag = "16.04";
  };
in dockerTools.buildImage {
  name = "shopsafe";
  fromImage = image;
}