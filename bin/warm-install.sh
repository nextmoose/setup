#!/bin/sh

sh $(dirname ${0})/destroy-dot-ssh.sh &&
    SYMMETRIC_PASSPHRASE=$(uuidgen) &&
    USER_PASSWORD=$(uuidgen) &&
    sh $(dirname ${0})/create-dot-ssh.sh &&
    (cat <<EOF
${SYMMETRIC_PASSPHRASE}
${SYMMETRIC_PASSPHRASE}
${USER_PASSWORD}
${USER_PASSWORD}
EOF
    ) | sh $(dirname ${0})/create-virtual-iso.sh &&
    sudo VBoxManage controlvm nixos poweroff soft &&
    sudo VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium build/box/nixos.vmdk &&
    sudo VBoxManage startvm --type headless nixos &&
    rm --force ~/.ssh/virtual-install.known_hosts &&
    while [ -z "$(cat build/dot-ssh/install.known_hosts)" ]
    do
	sleep 1s &&
	    ssh-keyscan -p 20560 127.0.0.1 > ~/.ssh/virtual-install.known_hosts
    done &&
    LUKS_PASSPHRASE=$(uuidgen) &&
    (cat <<EOF
${SYMMETRIC_PASSPHRASE}
${SYMMETRIC_PASSPHRASE}
${LUKS_PASSPHRASE}
${LUKS_PASSPHRASE}
EOF
    ) | time ssh -F build/dot-ssh/config install installer --no-shutdown --no-volumes &&
    sudo VBoxManage controlvm nixos poweroff soft &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
    sh $(dirname ${0})/boot.sh &&
    true
