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
	--origin-id-rsa)
	    export ORIGIN_ID_RSA="$(pass show ${2})" &&
		shift 2
	    ;;
	--origin-known-hosts)
	    export ORIGIN_KNOWN_HOSTS="$(pass show ${2})" &&
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
	ORIGIN_HOST=github.com
    fi &&
    if [ -z "${ORIGIN_PORT}" ]
    then
	ORIGIN_PORT=22
    fi &&
    if [ -z "${ORIGIN_USER}" ]
    then
	ORIGIN_USER=git
    fi &&
    if [ -z "${GPG_SECRET_KEY}" ]
    then
	GPG_SECRET_KEY="$(pass show gpg.secret.key)"
    fi &&
    if [ -z "${GPG_OWNER_TRUST}" ]
    then
	GPG_OWNER_TRUST="$(pass show gpg.owner.trust)"
    fi &&
    if [ -z "${GPG2_SECRET_KEY}" ]
    then
	GPG2_SECRET_KEY="$(pass show gpg2.secret.key)"
    fi &&
    if [ -z "${GPG2_OWNER_TRUST}" ]
    then
	GPG2_OWNER_TRUST="$(pass show gpg2.owner.trust)"
    fi &&
    if [ -z "${ORIGIN_ORGANIZATION}" ]
    then
	ORIGIN_ORGANIZATION=nextmoose
    fi &&
    if [ -z "${ORIGIN_REPOSITORY}" ]
    then
	ORIGIN_REPOSITORY=credentials
    fi &&
    if [ -z "${ORIGIN_ID_RSA}" ]
    then
	ORIGIN_ID_RSA="$(pass show origin.id_rsa)"
    fi &&
    if [ -z "${ORIGIN_KNOWN_HOSTS}" ]
    then
	ORIGIN_KNOWN_HOSTS="$(pass show origin.known_hosts)"
    fi &&
    if [ -z "${COMMITTER_NAME}" ]
    then
	COMMITTER_NAME="Emory Merryman"
    fi &&
    if [ -z "${COMMITTER_EMAIL}" ]
    then
	COMMITTER_EMAIL="emory.merryman@gmail.com"
    fi &&
    export HOME=$(mktemp -d) &&
    cd ${HOME} &&
    TMP=$(mktemp -d ${HOME}/XXXXXXXX) &&
    echo "${GPG_SECRET_KEY}" > ${TMP}/gpg.secret.key &&
    echo "${GPG_OWNER_TRUST}" > ${TMP}/gpg.owner.trust &&
    echo "${GPG2_SECRET_KEY}" > ${TMP}/gpg2.secret.key &&
    echo "${GPG2_OWNER_TRUST}" > ${TMP}/gpg2.owner.trust &&
    gpg --import ${TMP}/gpg.secret.key &&
    gpg --import-ownertrust ${TMP}/gpg.owner.trust &&
    gpg2 --import ${TMP}/gpg2.secret.key &&
    gpg2 --import-ownertrust ${TMP}/gpg2.owner.trust &&
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
    echo "${ORIGIN_ID_RSA}" > .ssh/origin.id_rsa &&
    chmod 0600 .ssh/origin.id_rsa &&
    echo "${ORIGIN_KNOWN_HOSTS}" > .ssh/known_hosts &&
    chmod 0644 .ssh/known_hosts &&
    pass init $(gpg-key-id) &&
    pass git init &&
    ln --symbolic $(which post-commit) .password-store/.git/hooks &&
    pass git config user.name "${COMMITTER_NAME}" &&
    pass git config user.email "${COMMITTER_EMAIL}" &&
    pass git remote add origin origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git &&
    export GIT_SSH_COMMAND="ssh -F ${HOME}/.ssh/config" &&
    pass git fetch origin master &&
    pass git checkout master &&
    bash
