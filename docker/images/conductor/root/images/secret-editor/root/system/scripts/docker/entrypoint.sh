#!/bin/sh

GPG_SECRET_KEY_FILE=$(mktemp) &&
	GPG_OWNER_TRUST_FILE=$(mktemp) &&
	echo "${GPG_SECRET_KEY}" > ${GPG_SECRET_KEY_FILE} &&
	echo "${GPG_OWNER_TRUST}" > ${GPG_OWNER_TRUST_FILE} &&
	gpg --import ${GPG_SECRET_KEY_FILE} &&
	gpg --import-ownertrust ${GPG_OWNER_TRUST_FILE} &&
	rm -f ${GPG_SECRET_KEY_FILE} ${GPG_OWNER_TRUST_FILE} &&
	(cat > ${HOME}/.ssh/config <<EOF
Host origin
HostName ${ORIGIN_HOST}
Port ${ORIGIN_PORT}
User ${ORIGIN_USER}
IdentityFile ~/.ssh/origin.id_rsa
EOF
	) &&
	echo "${ORIGIN_ID_RSA}" > ${HOME}/.ssh/origin.id_rsa &&
	ssh-keyscan -p ${ORIGIN_PORT} ${ORIGIN_HOST} > ${HOME}/.ssh/known_hosts &&
	chmod 0600 ${HOME}/.ssh/config ${HOME}/.ssh/origin.id_rsa &&
	pass init $(gpg --list-keys | grep "^pub" | sed -e "s#^pub.*/##" -e "s# .*\$##") &&
	pass git init &&
	pass git remote add origin origin:${ORIGIN_ORGANIZATION}/${ORIGIN_REPOSITORY}.git &&
	pass git config user.name "${COMMITTER_NAME}" &&
	pass git config user.email "${COMMITTER_EMAIL}" &&
	pass git fetch origin master &&
	pass git checkout master &&
	cp /opt/system/scripts/bin/post-commit.sh ${HOME}/.password-store/.git/hooks/post-commit &&
	chmod 0500 ${HOME}/.password-store/.git/hooks/post-commit &&
	bash &&
	true
	
