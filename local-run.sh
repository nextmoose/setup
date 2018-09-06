#!/bin/sh

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) &&
    cleanup() {
	echo AA1 &&
	git checkout ${CURRENT_BRANCH} &&
	echo AA2 &&
	    sudo sh ./run.sh --source configuration --destination /etc/nixos &&
	echo AA4 &&
	    sudo cp configuration/containers.nix /etc/nixos &&
	echo AA5 &&
	    sudo cp -r configuration/containers /etc/nixos &&
	echo AA6 &&
	    sudo cp -r configuration/custom /etc/nixos &&
	    for CONTAINER in $(sudo nixos-container list)
	    do
		sudo nixos-container stop ${CONTAINER}
	    done &&
	echo AA7 &&
	    sudo nixos-rebuild switch &&
	echo AA8 &&
	    for CONTAINER in $(sudo nixos-container list)
	    do
		sudo nixos-container start ${CONTAINER}
	    done &&
	    echo AA9 &&
	    true
    } &&
    trap cleanup EXIT &&
    TEST_BRANCH=scratch/$(uuidgen) &&
    git checkout -b ${TEST_BRANCH} &&
    git commit -am "before test local rebuild" --allow-empty &&
    sudo rm -rf /etc/nixos/custom &&
    sudo rm -rf /etc/nixos/containers &&
    sudo sed -e "s#\${PASSWORD_HASH}#${PASSWORD_HASH}#" -e "w/etc/nixos/configuration.nix" configuration/configuration.nix &&
    sudo cp -r configuration/containers /etc/nixos &&
    sudo cp -r configuration/containers /etc/nixos &&
    sudo cp -r configuration/custom /etc/nixos &&
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
