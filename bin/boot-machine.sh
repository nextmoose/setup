#!/bin/sh

read -s -p "LUKS PASSPHRASE? " LUKS_PASSPHRASE &&
    sudo VBoxManage startvm nixos &&
    sleep 60s &&
    echo "${LUKS_PASSPHRASE}" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-enter.sh &&
    true
