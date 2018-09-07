#!/bin/sh

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) &&
    cleanup() {
	echo DDD 1 &&
	    git checkout ${CURRENT_BRANCH} &&
	    echo DDD 3 &&
	    sudo sh ./run.sh --source configuration --destination /etc/nixos --user-password "${@}" &&
	    echo DDD 4 &&
	    for CONTAINER in $(sudo nixos-container list)
	    do
        	sudo nixos-container stop ${CONTAINER}
	    done &&
	    echo DDD 5 &&
	    sudo nixos-rebuild switch &&
	    echo DDD 6 &&
	    for CONTAINER in $(sudo nixos-container list)
	    do
		sudo nixos-container start ${CONTAINER}
	    done &&
	    echo DDD 7 &&
	    true
    } &&
    trap cleanup EXIT &&
    TEST_BRANCH=scratch/$(uuidgen) &&
    git checkout -b ${TEST_BRANCH} &&
    git commit -am "before test local rebuild" --allow-empty &&
    sudo sh ./run.sh --source configuration --destination /etc/nixos --user-password password &&
    for CONTAINER in $(sudo nixos-container list)
    do
	sudo nixos-container stop ${CONTAINER}
    done &&
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
    true
