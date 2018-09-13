#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--source)
	    export SOURCE="${2}" &&
		shift 2
	    ;;
	--destination)
	    export DESTINATION="${2}" &&
		shift 2
	    ;;
	--user-password)
	    export HASHED_USER_PASSWORD="$(echo ${2} | mkpasswd --stdin -m sha-512)" &&
		shift 2
	    ;;
	--containers)
	    export CONTAINERS="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done &&
    if [ -z "${SOURCE}" ]
    then
	echo Unspecifed SOURCE &&
	    exit 65
    elif [ -z "${DESTINATION}" ]
    then
	echo Unspecified DESTINATION &&
	    exit 66
    elif [ -z "${HASHED_USER_PASSWORD}" ]
    then
	 echo Unspecified USER_PASSWORD &&
	     exit 67
    fi &&
    rm -rf ${DESTINATION}/configuration.nix ${DESTINATION}/containers.nix ${DESTINATION}/containers ${DESTINATION}/custom &&
    sed -e "s#\${PASSWORD_HASH}#${HASHED_USER_PASSWORD}#" -e "w${DESTINATION}/configuration.nix" ${SOURCE}/configuration.nix &&
    sh ./containers.sh --destination ${DESTINATION} --containers ${CONTAINERS} &&
    cp -r ${SOURCE}/containers ${SOURCE}/custom ${DESTINATION} &&
    true
