#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--upstream-host)
	    UPSTREAM_HOST="${2}" &&
		shift 2
	;;
	--upstream-port)
	    UPSTREAM_PORT="${2}" &&
		shift 2
	    ;;
	--upstream-organization)
	    UPSTREAM_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--upstream-repository)
	    UPSTREAM_REPOSITORY="${2}" &&
		shift 2
	    ;;
	--upstream-user)
	    UPSTREAM_USER="${2}" &&
		shift 2
	    ;;
	--upstream-branch)
	    UPSTREAM_BRANCH="${2}" &&
		shift 2
	    ;;
	--upstream-id-rsa)
	    UPSTREAM_ID_RSA="$(pass show ${2})" &&
		shift 2
	    ;;
	--upstream-known-hosts)
	    UPSTREAM_KNOWN_HOSTS="$(pass show ${2})" &&
		shift 2
	    ;;
	--origin-host)
	    ORIGIN_HOST="${2}" &&
		shift 2
	;;
	--origin-port)
	    ORIGIN_PORT="${2}" &&
		shift 2
	    ;;
	--origin-organization)
	    ORIGIN_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--origin-repository)
	    ORIGIN_REPOSITORY="${2}" &&
		shift 2
	    ;;
	--origin-user)
	    ORIGIN_USER="${2}" &&
		shift 2
	    ;;
	--origin-branch)
	    ORIGIN_BRANCH="${2}" &&
		shift 2
	    ;;
	--origin-id-rsa)
	    ORIGIN_ID_RSA="$(pass show ${2})" &&
	    	shift 2
	    ;;
	--origin-known-hosts)
	    ORIGIN_KNOWN_HOSTS="$(pass show ${2})" &&
		shift 2
	    ;;
	--report-host)
	    REPORT_HOST="${2}" &&
		shift 2
	;;
	--report-port)
	    REPORT_PORT="${2}" &&
		shift 2
	    ;;
	--report-organization)
	    REPORT_ORGANIZATION="${2}" &&
		shift 2
	    ;;
	--report-repository)
	    REPORT_REPOSITORY="${2}" &&
		shift 2
	    ;;
	--report-user)
	    REPORT_USER="${2}" &&
		shift 2
	    ;;
	--report-branch)
	    REPORT_BRANCH="${2}" &&
		shift 2
	    ;;
	--report-id-rsa)
	    REPORT__ID_RSA="$(pass show ${2})" &&
	    	shift 2
	    ;;
	--report-known-hosts)
	    REPORT_KNOWN_HOSTS="$(pass show ${2})" &&
		shift 2
	    ;;
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2
	    ;;
	--committer-email)
	    COMMITER_EMAIL="${2}" &&
		shift 2
	    ;;
	*)
	    echo Unsupported Option &&
		echo ${1} &&
		echo ${@} &&
		echo ${0} &&
		exit 64
    esac
done &&
    if [ -z "${UPSTREAM_HOST}" ]
    then
	UPSTREAM_HOST=github.com
    fi &&
    if [ -z "${UPSTREAM_PORT}" ]
    then
	UPSTREAM_PORT=22
    fi &&
    if [ -z "${UPSTREAM_USER}" ]
    then
	UPSTREAM_USER=git
    fi &&
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
    if [ -z "${REPORT_HOST}" ]
    then
	REPORT_HOST=github.com
    fi &&
    if [ -z "${REPORT_PORT}" ]
    then
	REPORT_PORT=22
    fi &&
    if [ -z "${REPORT_USER}" ]
    then
	REPORT_USER=git
    fi &&
    PROJECT_DIR=$(mktemp -d) &&
    SSH_DIR=${PROJECT_DIR}/.ssh &&
    mkdir ${SSH_DIR} &&
    chmod 0700 ${SSH_DIR} &&
    touch ${SSH_DIR}/config &&
    chmod 0600 ${SSH_DIR}/config &&
    touch ${SSH_DIR}/known_hosts &&
    chmod 0600 ${SSH_DIR}/known_hosts &&
    if [ ! -z "${UPSTREAM_HOST}" ] && [ ! -z "${UPSTREAM_PORT}" ] && [ ! -z "${UPSTREAM_USER}" ] && [ ! -z "${UPSTREAM_ID_RSA}" ]
    then
	echo "${UPSTREAM_ID_RSA}" > ${SSH_DIR}/upstream.id_rsa &&
	    chmod 0700 ${SSH_DIR}/upstream.id_rsa &&
	    (cat >> ${SSH_DIR}/config <<EOF
Host upstream
HostName ${UPSTREAM_HOST}
Port ${UPSTREAM_PORT}
User ${UPSTREAM_USER}
IdentityFile ${SSH_DIR}/upstream.id_rsa
UserKnownHostsFile ${SSH_DIR}/known_hosts

EOF
	    ) &&
	    echo "${UPSTREAM_KNOWN_HOSTS}" >> ${SSH_DIR}/known_hosts
    fi &&
    if [ ! -z "${ORIGIN_HOST}" ] && [ ! -z "${ORIGIN_PORT}" ] && [ ! -z "${ORIGIN_USER}" ] && [ ! -z "${ORIGIN_ID_RSA}" ]
    then
	echo "${ORIGIN_ID_RSA}" > ${SSH_DIR}/origin.id_rsa &&
	    chmod 0700 ${SSH_DIR}/origin.id_rsa &&
	    (cat >> ${SSH_DIR}/config <<EOF
Host origin
HostName ${ORIGIN_HOST}
Port ${ORIGIN_PORT}
User ${ORIGIN_USER}
IdentityFile ${SSH_DIR}/origin.id_rsa
UserKnownHostsFile ${SSH_DIR}/known_hosts

EOF
	    ) &&
	    echo "${UPSTREAM_KNOWN_HOSTS}" >> ${SSH_DIR}/known_hosts
    fi &&
    if [ ! -z "${REPORT_HOST}" ] && [ ! -z "${REPORT_PORT}" ] && [ ! -z "${REPORT_USER}" ] && [ ! -z "${REPORT_ID_RSA}" ]
    then
	echo "${REPORT_ID_RSA}" > ${SSH_DIR}/report.id_rsa &&
	    chmod 0700 ${SSH_DIR}/report.id_rsa &&
	    (cat >> ${SSH_DIR}/config <<EOF
Host report
HostName ${REPORT_HOST}
Port ${REPORT_PORT}
User ${REPORT_USER}
IdentityFile ${SSH_DIR}/report.id_rsa
UserKnownHostsFile ${SSH_DIR}/known_hosts

EOF
	    ) &&
	    echo "${UPSTREAM_KNOWN_HOSTS}" >> ${SSH_DIR}/known_hosts
    fi &&
    export GIT_SSH_COMMAND="ssh -F ${SSH_DIR}/config" &&
    WORK_DIR=${PROJECT_DIR}/work &&
    (cat > ${PROJECT_DIR}/.emacs <<EOF
(autoload 'magit-status "magit" nil t)
EOF
    ) &&
    mkdir ${WORK_DIR} &&
    cd ${WORK_DIR} &&
    git init &&
    git config user.name "${COMMITTER_NAME}" &&
    git config user.email "${COMMITER_EMAIL}" &&
    git config --global user.signingkey $(gpg-key-id) &&
    ln --symbolic ${HOME}/bin/post-commit ${HOME}/bin/pre-push .git/hooks &&
    git remote add upstream upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git &&
    git remote add origin origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git &&
    git remote add report report:${REPORT_ORGANIZATION}/${REPORT_REPOSITORY}.git &&
    bash &&
    if [ ! -z "${ORIGIN_BRANCH}" ]
    then
	git fetch origin ${ORIGIN_BRANCH} &&
	    git checkout ${ORIGIN_BRANCH}
    elif [ ! -z "${UPSTREAM_BRANCH}" ]
    then
	git fetch upstream ${UPSTREAM_BRANCH} &&
	    git checkout upstream/${UPSTREAM_BRANCH} &&
	    git checkout -b scratch/$(uuidgen)
    fi &&
    export HOME=${PROJECT_DIR} &&
    emacs . &&
    rm -rf ${PROJECT_DIR} &&
    true
