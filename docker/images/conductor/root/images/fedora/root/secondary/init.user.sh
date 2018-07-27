#!/bin/sh

gpg --import /run/gpg.secrets/gpg.secret.key &&
	gpg --import-ownertrust /run/gpg.secrets/gpg.owner.trust &&
	pass init $(gpg --list-keys | grep "^pub" | sed -e "s#^.*/##" -e "s# .*\$##") &&
	pass git init &&
	UPSTREAM_HOST=github.com &&
	UPSTREAM_ORGANIZATION=nextmoose &&
	UPSTREAM_REPOSITORY=secrets &&
	pass git remote add upstream https://${UPSTREAM_HOST}/${UPSTREAM_ORGANIZATION}/${UPSTREAM_REPOSITORY}.git &&
	pass git remote set-url --push upstream no_push &&
	cp /opt/system/secondary/pre-commit.sh ${HOME}/.password-store/.git/hooks/pre-commit &&
	chmod 0500 ${HOME}/.password-store/.git/hooks/pre-commit &&
	pass git fetch upstream master &&
	pass git checkout upstream/master
