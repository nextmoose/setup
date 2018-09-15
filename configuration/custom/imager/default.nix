{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
pkgs.writeShellScriptBin "imager" ''
  sudo lvcreate --name image --size 10G volumes &&
    sudo mount /dev/image /tmp/image
''
