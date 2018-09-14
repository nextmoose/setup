{ pkgs ? import <nixpkgs> {} }:
with import <nixpkgs> {};
pkgs.writeShellScriptBin "gpg-key-id" "${pkgs.gnupg}/bin/gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter 'A'"
