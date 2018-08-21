#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--gpg-secret-key)
	    export GPG_SECRET_KEY="$(pass show ${2})" &&
		shift 2
	    ;;
	--gpg-owner-trust)
	    export GPG_OWNER_TRUST="$(pass show ${2})" &&
		shift 2
	    ;;
	--gpg2-secret-key)
	    export GPG2_SECRET_KEY="$(pass show ${2})" &&
		shift 2
	    ;;
	--gpg2-owner-trust)
	    export GPG2_OWNER_TRUST="$(pass show ${2})" &&
		shift 2
	    ;;
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${@} &&
		echo ${0} &&
		exit 64
    esac
done &&
    if [ -z "${GPG_SECRET_KEY}" ]
    then
	echo Unspecified GPG_SECRET_KEY &&
	    exit 65
    elif [ -z "${GPG_OWNER_TRUST}" ]
    then
	echo Unspecified GPG_OWNER_TRUST &&
	    exit 66
    elif [ -z "${GPG2_SECRET_KEY}" ]
    then
	echo Unspecified GPG2_SECRET_KEY &&
	    exit 67
    elif [ -z "${GPG2_OWNER_TRUST}" ]
    then
	echo Unspecified GPG2_OWNER_TRUST &&
	    exit 68
    fi &&
    export HOME=$(mktemp -d) &&
    cd ${HOME} &&
    echo "${GPG_SECRET_KEY}" > gpg.secret.key &&
    echo "${GPG_OWNER_TRUST}" > gpg.owner.trust &&
    echo "${GPG2_SECRET_KEY}" > gpg2.secret.key &&
    echo "${GPG2_OWNER_TRUST}" > gpg2.owner.trust &&
    gpg --import gpg.secret.key &&
    gpg --import-ownertrust gpg.owner.trust &&
    gpg2 --import gpg2.secret.key &&
    gpg2 --import-ownertrust gpg2.owner.trust &&
    pass git init $(gpg-key-id) &&
    pass git remote add origin git@github.com/desertedscorpion/passwordstore.git &&
    pass git fetch origin master &&
    pass git checkout origin/master &&
    bash
