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
	--committer-name)
	    COMMITTER_NAME="${2}" &&
		shift 2
	    ;;
	--committer-email)
	    COMMITER_EMAIL="${2}" &&
		shift 2
	    ;;
	--work-dir-size)
	    WORK_DIR_SIZE="${2}" &&
		shift 2
	    ;;
    esac
done &&
    SSH_DIR=$(mktemp -d) &&
    chmod 0700 ${SSH_DIR} &&
    echo "${UPSTREAM_ID_RSA}" > ${SSH_DIR}/upstream.id_rsa &&
    chmod 0700 ${SSH_DIR}/upstream.id_rsa &&
    (cat > ${SSH_DIR}/config <<EOF
Host upstream
HostName ${UPSTREAM_HOST}
Port ${UPSTREAM_PORT}
User ${UPSTREAM_USER}
EOF
    ) &&
    export GIT_SSH_COMMAND="ssh -F ${SSH_DIR}" &&
    WORK_DIR=$(mktemp -d) &&
    cd ${WORK_DIR} &&
    git init &&
    git remote add upstream upstream:${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git &&
    git fetch upstream ${UPSTREAM_BRANCH} &&
    git checkout upstream/${UPSTREAM_BRANCH}
