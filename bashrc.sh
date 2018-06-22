#!/bin/sh

if [ -f wifi.sh ]
then
    while ! nmcli device wifi rescan
    do
	sleep 1s
    done &&
	sh wifi.sh &&
	gpg --import gpg.secret.key &&
	gpg --import-ownertrust gpg.owner.trust &&
	source public.env &&
	pass init "${GPG_KEY_ID}" &&
	pass git init &&
	pass git config user.name "${USER_NAME}" &&
	pass git config user.email "${USER_EMAIL}" &&
	pass git remote add readonly https://github.com/desertedscorpion/passwordstore.git &&
	pass git fetch readonly master &&
	pass git checkout readonly/master &&
	rm wifi.sh gpg.secret.key gpg.owner.trust public.env
    fi
