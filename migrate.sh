#!/bin/sh

mkdir configuration/custom/migration &&
    ls -1 bin | while read FILE
    do
	mkdir configuration/custom/migration/${FILE%.*} &&
	    sed -e "s#myshell#${FILE%.*}#" -e "wconfiguration/custom/migration/${FILE%.*}/default.nix" configuration/custom/myshell/default.nix &&
	    git add configuration/custom/migration/${FILE%.*}/default.nix &&
	    mkdir configuration/custom/migration/${FILE%.*}/src &&
	    git mv bin/${FILE} configuration/custom/migration/${FILE%.*}/src 
    done &&
    ls -1 configuration/custom/migration | while read FILE
    do
	echo "(import ./custom/migratin/${FILE}/default.nix { inherit pkgs; })"
    done
