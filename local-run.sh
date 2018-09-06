#!/bin/sh

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) &&
    cleanup() {
	git checkout ${CURRENT_BRANCH} &&
	    sudo sh ./run.sh --source configuration --destination /etc/nixos --password password &&
	    for CONTAINER in $(sudo nixos-container list)
	    do
        	sudo nixos-container stop ${CONTAINER}
	    done &&
	    sudo nixos-rebuild switch &&
	    for CONTAINER in $(sudo nixos-container list)
	    do
		sudo nixos-container start ${CONTAINER}
	    done &&
	    true
    } &&
    trap cleanup EXIT &&
    TEST_BRANCH=scratch/$(uuidgen) &&
    git checkout -b ${TEST_BRANCH} &&
    git commit -am "before test local rebuild" --allow-empty &&
    sudo sh ./run.sh --source configuration --destination /etc/nixos --password password &&
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
	    git commit -am "after test local rebuild" --allow-empty
    elif [ "M" == "${ISITOK}" ]
    then
	git commit -am "IT IS NOT OK YET" --allow-empty &&
	    echo ${TEST_BRANCH}
    fi
