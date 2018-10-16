#!/bin/sh

read -s -p "SYMMETRIC PASSWORD? " SYMMETRIC_PASSWORD &&
    echo &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium build/installation/result/iso/nixos-18.03.133245.d16a7abceb7-x86_64-linux.iso &&
    sudo VBoxManage startvm nixos &&
    sleep 60s &&
    echo "echo ${SYMMETRIC_PASSWORD} | installer --no-shutdown --no-volumes" | sed -e "s# #_#g" | sh $(dirname ${0})/sendkeyboardscancode.sh &&
    sleep 30s &&
    sudo VBoxManage controlvm nixos poweroff soft &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium emptydrive &&
    true
