#!/bin/sh

sh $(dirname ${0})/create-real.sh &&
    (
	cd build/real &&
	    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    true
