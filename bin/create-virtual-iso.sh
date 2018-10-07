#!/bin/sh

sh $(dirname ${0})/create-virtual.sh &&
    (
	cd build/virtual &&
	    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    true
