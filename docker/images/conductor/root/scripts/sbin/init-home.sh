#!/bin/sh

gpg --import /run/gpg.secrets/gpg.secret.key &&
	gpg --import-ownertrust /run/gpg.secrets/gpg.owner.trust &&
	pass init $(gpg --list-keys | grep "^pub" | sed -e "s#^pub.*/##" -e "s# .*\$##") &&
	pass git init &&
	pass git remote add upstream ${UPSTREAM_URL} &&
	pass git fetch upstream master &&
	pass git checkout upstream/master
