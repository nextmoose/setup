#!/bin/sh

mkdir /tmp/setup &&
    sudo mount /dev/sdb1 /tmp/setup &&
    gpg --import /tmp/setup/startup/private/gpg.secret.key &&
    gpg --import-ownertrust /tmp/setup/startup/private/gpg.owner.trust &&
    source /tmp/setup/startup/public.env &&
    umount /tmp/setup &&
    rm --recursive /tmp/setup &&
    pass init "${GPG_KEY_ID}" &&
    pass git init &&
    pass git config user.name "${USER_NAME}" &&
    pass git config user.email "${USER_EMAIL}" &&
    pass git remote add readonly https://github.com/desertedscorpion/passwordstore.git &&
    pass git fetch readonly master &&
    pass git checkout readonly/master
