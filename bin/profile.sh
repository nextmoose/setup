#!/bin/sh

nmcli device wifi rescan &&
    nmcli device wifi connect "Richmond SQ Guest" "guestwifi" &&
    if [ $(last user | wc -l) -lt 3 ]
    then
	gpg --import gpg.secret.key &&
	    gpg --import-ownertrust gpg.ownertrust &&
	    source public.env &&
	    pass init "${GPG_KEY_ID}" &&
	    pass git init &&
	    pass git config user.name "${USER_NAME}" &&
	    pass git config user.email "${USER_EMAIL}" &&
	    pass git remote readonly https://github.com/desertedscorpion/passwordstore.git &&
	    pass git fetch readonly master &&
	    pass git checkout readonly/master
    fi
