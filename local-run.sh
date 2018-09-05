#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--password)
	    export PASSWORD_HASH="$(echo ${2} | mkpasswd --stdin -m sha-512)" &&
		shift 2
	;;
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done &&
    if [ -z "${PASSWORD_HASH}" ]
    then
	PASSWORD_HASH=$(mkpasswd -m sha-512)
    fi &&
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD) &&
    cleanup() {
	git checkout ${CURRENT_BRANCH} &&
	    sudo rm -rf /etc/nixos/custom &&
	    sudo rm -rf /etc/nixos/containers &&
	    sudo sed -e "#\${PASSWORD_HASH}#${HASHED_PASSWORD}#" -e "w/etc/nixos/configuration.nix" configuration/configuration.nix &&
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
	    done
    } &&
    trap cleanup EXIT &&
    TEST_BRANCH=scratch/$(uuidgen) &&
    git checkout -b ${TEST_BRANCH} &&
    git commit -am "before test local rebuild" --allow-empty &&
    sudo rm -rf /etc/nixos/custom &&
    sudo rm -rf /etc/nixos/containers &&
    sudo cp -r configuration/. /etc/nixos &&
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
