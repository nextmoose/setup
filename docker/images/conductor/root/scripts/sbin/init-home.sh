#!/bin/sh

while [ ${#} -gt 0 ]
do
	case ${1} in
		--upstream-url)
			UPSTREAM_URL="${2}" &&
				shift 2
			;;
		*)
			echo Unsupported Option &&
				echo ${1} &&
				echo ${0} &&
				echo ${@} &&
				exit 64
			;;
	esac
done &&
	if [ -z "${UPSTREAM_URL}" ]
	then
		echo Unspecified UPSTREAM_URL &&
			exit 65
	fi
	gpg --import /run/gpg.secrets/gpg.secret.key &&
	gpg --import-ownertrust /run/gpg.secrets/gpg.owner.trust &&
	pass init $(gpg --list-keys | grep "^pub" | sed -e "s#^pub.*/##" -e "s# .*\$##") &&
	pass git init &&
	pass git remote add upstream ${UPSTREAM_URL} &&
	pass git fetch upstream master &&
	pass git checkout upstream/master
