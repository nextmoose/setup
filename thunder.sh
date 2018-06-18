#!/bin/sh

mkdir -p ${HOME}/bin &&
    ls -1 bin | while read FILE
    do
	cp bin/${FILE} ${HOME}/bin/${FILE%.*} &&
	    chmod 0500 ${HOME}/bin/${FILE%.*}
    done

