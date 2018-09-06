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
    fi &&
    HASHED_USER_PASSWORD=$(uuidgen | mkpasswd -m sha-512) &&
    rm -rf ${DESTINATION}/configuration.nix ${DESTINATION}/containers.nix ${DESTINATION}/containers ${DESTINATION}/custom &&
    sed -e "s#\${PASSWORD_HASH}#${HASHED_USER_PASSWORD}#" -e "w${DESTINATION}/configuration.nix" ${SOURCE}/configuration.nix &&
    cp -r ${SOURCE}/containers.nix ${SOURCE}/containers ${SOURCE}/custom ${DESTINATION}
