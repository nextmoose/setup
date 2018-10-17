{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
#  secrets = (import ../../secrets/default.nix { inherit pkgs; });
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}
    set -e
    bash
#    ${pkgs.gnupg}/bin/gpg --import ${secrets}/bin/secrets show gpg.secret.key &&
#    ${pkgs.gnupg}/bin/gpg --import-ownertrust ${secrets}/bin/secrets show gpg.owner.trust &&
#    ${pkgs.gnupg}/bin/gpg2 --import ${secrets}/bin/secrets show gpg2.secret.key &&
#    ${pkgs.gnupg}/bin/gpg2 --import-ownertrust ${secrets}/bin/secrets show gpg2.owner.trust &&
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