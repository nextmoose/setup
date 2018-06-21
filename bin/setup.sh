#!/bin/sh

gpg --import private/gpg.secret.key &&
    gpg --import-ownertrust gpg.ownertrust &&
    source public.env &&
    pass git init "${GPG_KEY_ID}" &&
    pass git config user.name "${USER_NAME}" &&
    pass git config user.email "${USER_EMAIL}" &&
    pass git remote add readonly https://github.com/desertedscorpion/passwordstore.git &&
    pass git fetch readonly master &&
    pass git checkout master
