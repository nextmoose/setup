#!/bin/sh

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) &&
    cleanup() {
	git checkout ${CURRENT_BRANCH} &&
	    sudo rm -rf /etc/nixos/custom &&
	    sudo rm -rf /etc/nixos/containers &&
	    sudo cp -r configuration/. /etc/nixos &&
	    for CONTAINER in $(sudo nixos-container ls)
	    do
		sudo nixos-container stop ${CONTAINER}
	    done &&
	    sudo nixos-rebuild switch &&
	    for CONTAINER in $(sudo nixos-container ls)
	    do
		sudo nixos-container start ${CONTAINER}
	    done
    } &&
    trap cleanup EXIT &&
    TEST_BRANCH=scratch/$(uuidgen) &&
    git checkout -b ${TEST_BRANCH} &&
    git commit -am "before test local rebuild" --allow-empty &&
    sudo rm -rf /etc/nixos/custom &&
    sudo rm -rf /etc/nixos/containers &&
    sudo cp -r configuration/. /etc/nixos &&
    for CONTAINER in $(sudo nixos-container ls)
    do
	sudo nixos-container stop ${CONTAINER}
    done &&
    sudo nixos-rebuild switch &&
    for CONTAINER in $(sudo nixos-container ls)
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
    fi
