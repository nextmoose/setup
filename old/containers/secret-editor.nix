{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  entrypoint = writeScript "entrypoint.sh" ''
    #!${stdenv.shell}

    ${coreutils}/bin/pwd &&
    ${coreutils}/bin/ls -alh /home &&
      ${gnupg}/bin/gpg --import /secrets/gpg.secret.key &&
      ${gnupg}/bin/gpg --import-ownertrust /secrets/gpg.owner.trust &&
      ${pass}/bin/pass init $(${gnupg}/bin/gpg --list-keys --with-colon | ${coreutils}/bin/head --lines 5 | ${coreutils}/bin/tail --lines 1 | ${coreutils}/bin/cut --fields 5 --delimiter ":") &&
      ${pass}/bin/pass git init &&
      ${coreutils}/bin/mkdir .ssh &&
      ${coreutils}/bin/chmod 0700 .ssh &&
      ${coreutils}/bin/echo -en "Host origin\nHostName github.com\nUser git\nIdentityFile ~/.ssh/origin.id_rsa\nUserKnownHostsFile ~/.ssh/origin.known_hosts" > .ssh/config &&
      ${coreutils}/bin/chmod 0600 .ssh/config &&
      ${coreutils}/bin/cat /secrets/origin.id_rsa > .ssh/origin.id_rsa &&
      ${coreutils}/bin/chmod 0600 .ssh/origin.id_rsa &&
      ${coreutils}/bin/cat /secrets/origin.known_hosts > .ssh/origin.known_hosts &&
      ${coreutils}/bin/chmod 0600 .ssh/origin.known_hosts &&
      ${pass}/bin/pass git remote add origin origin:desertedscorpion/passwordstore.git &&
      ${pass}/bin/pass git config user.name "Emory Merryman" &&
      ${pass}/bin/pass git config user.email "emory.merryman@gmail.com" &&
      ${pass}/bin/pass git fetch origin master &&
      ${pass}/bin/pass git checkout master &&
      ${bash}/bin/bash &&
      true
  '';
in
dockerTools.buildImage {
  name = "secret-editor";
  runAsRoot = ''
    #!${stdenv.shell}
    
      ${dockerTools.shadowSetup}
      mkdir /home
      useradd --create-home user
  '';
  config = {
    WorkingDir = "/home/user";
    User = "user";
    Entrypoint = entrypoint;
    Env = [
      "PATH=${pass}/bin:${findutils}/bin:${gnugrep}/bin:${coreutils}/bin"
    ];
  };
}