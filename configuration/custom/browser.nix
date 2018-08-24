/*
This is a nix expression to build Emacs and some Emacs packages I like
from source on any distribution where Nix is installed. This will install
all the dependencies from the nixpkgs repository and build the binary files
without interfering with the host distribution.

To build the project, type the following from the current directory:

$ nix-build chromium.nix

To run the newly compiled executable:

$ ./result/bin/chromium
*/
with import { 

{ pkgs ? import <nixpkgs> {} }:

pkgs.chromium.override{
  name = "shitty";
}