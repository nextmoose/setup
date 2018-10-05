#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--isonix)
	    ISONIX="${2}" &&
		shift 2
	    ;;
	--id-rsa-file)
	    ID_RSA_FILE="${2}" &&
		shift 2
	    ;;
	--symmetric-passphrase)
	    SYMMETRIC_PASSPHRASE="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unsupported Option &&
		echo ${1} &&
		echo ${@} &&
		echo ${0} &&
		exit 64
	    ;;
    esac
done &&
    if [ ! -f "${ISONIX}" ]
    then
	echo Missing ISONIX file &&
	    exit 65
    fi &&
    cp ${ISONIX} ${TARGET_DIR}/iso.nix &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/virtual/.ssh/id_rsa)#" \
	-e "w${TARGET_DIR}/iso.isolated.nix" \
	iso.virtual.nix.template &&
