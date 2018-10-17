#!/bin/sh

read -s -p "LUKS PASSPHRASE? " LUKS_PASSPHRASE &&
    echo &&
    read -s -p "USER PASSWORD? " USER_PASSWORD &&
    sudo VBoxManage startvm nixos &&
    sleep 30s &&
    echo "${LUKS_PASSPHRASE}" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-enter.sh &&
    sleep 30s &&
    echo user | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-enter.sh &&
    sleep 20s &&
    echo "${USER_PASSWORD}" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-enter.sh &&
    true
