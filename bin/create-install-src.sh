#!/bin/sh

if [ ! -d build ]
then
    mkdir build
fi &&
    if [ ! -d build/src ]
    then
	mkdir build/src
    fi &&
    cp src/iso.nix build/src &&
    cp --recursive src/custom build/src &&
    (cat > build/src/installer/src/hardware.nix <<EOF
{ config, lib, pkgs, ... }:
{
}
EOF
    ) &&
    (cat > build/src/installer/src/password.nix <<EOF &&
{ config, pkgs, ... }:
{
  users.extraUsers.user.hashedPassword = "$(echo password | mkpasswd --stdin -m sha-512)";
}
EOF
    ) &&
    true
