#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	*)
	    echo Unknown Option &&
		echo ${0} &&
		echo ${@} &&
	    ;;
    esac
done
