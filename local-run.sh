#!/bin/sh

DELTA=FAILED &&
    USER_PASSWORD=$(secrets user.password) &&
    if [ -z "${USER_PASSWORD}" ]
    then
	echo Unspecified USER_PASSWORD &&
	    exit 65
    fi &&
    if [ ! -z "$(git ls-files --other --exclude-standard --directory --exclude .c9)" ]
    then
	echo There are untracked files &&
	    exit 66
    fi &&
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) &&
    cleanup() {
	git checkout ${CURRENT_BRANCH} &&
	    sudo sh ./run.sh --source configuration --destination /etc/nixos --user-password "${USER_PASSWORD}" --containers true &&
	    sudo nixos-container list | while read CONTAINER
	    do
		sudo nixos-container stop ${CONTAINER}
	    done &&
	    sudo nixos-rebuild switch &&
	    for CONTAINER in $(sudo nixos-container list)
	    do
		sudo nixos-container start ${CONTAINER}
	    done &&
	    echo ${DELTA} &&
	    true
    } &&
    trap cleanup EXIT &&
    TEST_BRANCH=scratch/$(uuidgen) &&
    git checkout -b ${TEST_BRANCH} &&
    git commit -am "before test local rebuild" --allow-empty &&
    sudo sh ./run.sh --source configuration --destination /etc/nixos --user-password "${USER_PASSWORD}" --containers false &&
    sudo nixos-container list | while read CONTAINER
    do
	sudo nixos-container stop ${CONTAINER}
    done &&
    sudo nixos-rebuild switch &&
    sudo sh ./run.sh --source configuration --destination /etc/nixos --user-password "${USER_PASSWORD}" --containers true &&
    sudo nixos-rebuild switch &&
    for CONTAINER in $(sudo nixos-container list)
    do
	sudo nixos-container start ${CONTAINER}
    done &&
    read -p "IS IT OK? " ISITOK &&
    if [ "Y" == "${ISITOK}" ]
    then
	git rebase ${CURRENT_BRANCH} &&
	    git checkout ${CURRENT_BRANCH} &&
	    git rebase ${TEST_BRANCH} &&
	    git commit -am "after test local rebuild" --allow-empty &&
	    true
    elif [ "M" == "${ISITOK}" ]
    then
	git commit -am "IT IS NOT OK YET" --allow-empty &&
	    echo ${TEST_BRANCH}
    fi &&
    export DELTA=PASSED
    true
