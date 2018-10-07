#!/bin/sh

export PATH=${PATH}:GPG:PASS &&
    TEMP=$(mktemp -d) &&
    secrets gpg.secret.key > ${TEMP}/gpg.secret.key &&
    secrets gpg.owner.trust > ${TEMP}/gpg.owner.trust &&
    secrets gpg2.secret.key > ${TEMP}/gpg2.secret.key &&
    secrets gpg2.owner.trust > ${TEMP}/gpg2.owner.trust &&
    gpg --import ${TEMP}/gpg.secret.key &&
    gpg --import-ownertrust ${TEMP}/gpg.owner.trust &&
    gpg2 --import ${TEMP}/gpg2.secret.key &&
    gpg2 --import-ownertrust ${TEMP}/gpg2.owner.trust &&
    rm -rf ${TEMP} &&
    pass init $(gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
    pass git init &&
    ln --symbolic OUT/bin/post-commit ${HOME}/.password-store/.git/hooks &&
    pass git config user.name "Emory Merryman" &&
    pass git config user.email "emory.merryman@gmail.com" &&
    pass git remote add origin origin:desertedscorpion/passwordstore.git &&
    pass git fetch origin master &&
    pass git checkout master
