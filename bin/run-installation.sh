#!/bin/sh

read -s -p "SYMMETRIC PASSWORD? " SYMMETRIC_PASSWORD &&
    echo &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium build/installation/result/iso/nixos-18.03.133245.d16a7abceb7-x86_64-linux.iso &&
    sudo VBoxManage startvm nixos &&
    sleep 60s &&
    echo echo | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo ${SYMMETRIC_PASSWORD} | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo "|" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo installer | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo "--no-shutdown" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo "--no-volumes" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-enter.sh &&
    sleep 30s &&
    sudo VBoxManage controlvm nixos poweroff soft &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium emptydrive &&
    true
