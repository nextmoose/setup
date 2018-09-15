{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
pkgs.writeShellScriptBin "imager" ''
  cd $(mktemp -d) &&
    ${pkgs.curl}/bin/curl --output nixos-minimal-linux.iso https://d3g5gsiof5omrk.cloudfront.net/nixos/18.03/nixos-18.03.133224.5f59ab7d4e0/nixos-minimal-18.03.133224.5f59ab7d4e0-x86_64-linux.iso
    mkdir image &&
    sudo mount nixos-minimal-linux.iso image
''
