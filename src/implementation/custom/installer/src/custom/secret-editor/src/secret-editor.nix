{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}
    set -e
    ${pkgs.firefox}/bin/firefox
    true
  '';
in
dockerTools.buildImage {
  name = "secret-editor";
  runAsRoot = ''
    #!${stdenv.shell}
  '';
  config = {
    Cmd = [ "secret-editor" ];
    Entrypoint = [ entrypoint ];
    WorkingDir = "/home/user";
  };
}