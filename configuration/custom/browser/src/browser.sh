#!/bin/sh

export PATH=${PATH}:pkgs.git/bin:pkgs.gnupg/bin:pkgs.pass/bin:pkgs.chromium/bin:pkgs.gpg-key-id/bin &&
    while [ ${#} -gt 0 ]
    do
	case ${1} in
	    --gpg-secret-key-file)
		export GPG_SECRET_KEY_FILE="${2}" &&
		    shift 2
		;;
	    --gpg-owner-trust-file)
		export GPG_OWNER_TRUST_FILE="${2}" &&
		    shift 2
		;;
	    --gpg2-secret-key-file)
		export GPG2_SECRET_KEY_FILE="${2}" &&
		    shift 2
		;;
	    --gpg2-owner-trust-file)
		export GPG2_OWNER_TRUST_FILE="${2}" &&
		    shift 2
		;;
	    --origin-host)
		export ORIGIN_HOST="${2}" &&
		    shift 2
		;;
	    --origin-port)
		export ORIGIN_PORT="${2}" &&
		    shift 2
		;;
	    --origin-user)
		export ORIGIN_USER="${2}" &&
		    shift 2
		;;
	    --origin-organization)
		export ORIGIN_ORGANIZATION="${2}" &&
		    shift 2
		;;
	    --origin-repository)
		export ORIGIN_REPOSITORY="${2}" &&
		    shift 2
		;;
	    --origin-id-rsa-file)
		export ORIGIN_ID_RSA_FILE="${2}" &&
		    shift 2
		;;
	    --origin-known-hosts)
		export ORIGIN_KNOWN_HOSTS_FILE="${2}" &&
		    shift 2
		;;
	    --committer-name)
		export COMMITTER_NAME="${2}" &&
		    shift 2
		;;
	    --committer-email)
		export COMMITTER_EMAIL="${2}" &&
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
    if [ -z "${ORIGIN_HOST}" ]
    then
	echo Unspecified ORIGIN_HOST &&
	    exit 65
    elif [ -z "${ORIGIN_PORT}" ]
    then
	echo Unspecified ORIGIN_PORT &&
	    exit 66
    elif [ -z "${ORIGIN_USER}" ]
    then
	echo Unspecified ORIGIN_USER &&
	    exit 67
    elif [ -z "${GPG_SECRET_KEY_FILE}" ]
    then
	echo Unspecified GPG_SECRET_KEY_FILE &&
	    exit 68
    elif [ -z "${GPG_OWNER_TRUST_FILE}" ]
    then
	echo Unspecified GPG_OWNER_TRUST_FILE &&
	    exit 69
    elif [ -z "${GPG2_SECRET_KEY_FILE}" ]
    then
	echo Unspecified GPG2_SECRET_KEY_FILE &&
	    exit 70
    elif [ -z "${GPG2_OWNER_TRUST_FILE}" ]
    then
	echo Unspecified GPG2_OWNER_TRUST_FILE &&
	    exit 71
    elif [ -z "${ORIGIN_ORGANIZATION}" ]
    then
	echo Unspecified ORIGIN_ORGANIZATION &&
	    exit 72
    elif [ -z "${ORIGIN_REPOSITORY}" ]
    then
	echo Unspecified ORIGIN_REPOSITORY &&
	    exit 73
    elif [ -z "${ORIGIN_ID_RSA_FILE}" ]
    then
	echo Unspecified ORIGIN_ID_RSA_FILE &&
	    exit 74
    elif [ -z "${ORIGIN_KNOWN_HOSTS_FILE}" ]
    then
	echo Unspecified ORIGIN_KNOWN_HOSTS_FILE &&
	    exit 75
    elif [ -z "${COMMITTER_NAME}" ]
    then
	echo Unspecified COMMITTER_NAME &&
	    exit 76
    elif [ -z "${COMMITTER_EMAIL}" ]
    then
	echo Unspecified COMMITTER_EMAIL &&
	    exit 77
    fi &&
    gpg --import ${GPG_SECRET_KEY_FILE} &&
    gpg --import-ownertrust ${GPG_OWNER_TRUST_FILE} &&
    gpg2 --import ${GPG2_SECRET_KEY_FILE} &&
    gpg2 --import-ownertrust ${GPG2_OWNER_TRUST_FILE} &&
    mkdir .ssh &&
    chmod 0700 .ssh &&
    (cat > .ssh/config <<EOF
Host origin
HostName ${ORIGIN_HOST}
Port ${ORIGIN_PORT}
User ${ORIGIN_USER}
IdentityFile ${HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/known_hosts
EOF
    ) &&
    chmod 0600 .ssh/config &&
    cat "${ORIGIN_ID_RSA_FILE}" > .ssh/origin.id_rsa &&
    chmod 0600 .ssh/origin.id_rsa &&
    cat "${ORIGIN_KNOWN_HOSTS_FILE}" > .ssh/known_hosts &&
    chmod 0644 .ssh/known_hosts &&
    pass init $(gpg-key-id) &&
    pass git init &&
    ln --symbolic $(which post-commit) .password-store/.git/hooks &&
    pass git config user.name "${COMMITTER_NAME}" &&
    pass git config user.email "${COMMITTER_EMAIL}" &&
    pass git remote add origin origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git &&
    pass git fetch origin master &&
    pass git checkout master &&
    chromium --disable-gpu &&
    true
