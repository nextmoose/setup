#!/bin/sh

git init &&
	if [ ! -z "${UPSTREAM_URL}" ]
	then
		git remote add upstream "${UPSTREAM_URL}" &&
			git remote set-url --push origin no_push &&
			if [ ! -z "${MASTER_BRANCH}" ]
			then
				git fetch upstream ${MASTER_BRANCH} &&
					git checkout upstream/${MASTER_BRANCH}
			fi
	fi &&
	if [ ! -z "${ORIGIN_URL}" ]
	then
		git remote add origin "${ORIGIN_URL}"
	fi &&
	if [ ! -z "${REPORT_URL}" ]
	then
		git remote add report "${REPORT_URL}"
	fi &&
	git config user.name "${COMMITTER_NAME}" &&
	git config user.email "${COMMITTER_EMAIL}" &&
	cp /opt/scripts/post-commit.sh .git/hooks/post-commit &&
	chmod 0500 .git/hooks/post-commit &&
	emacs
