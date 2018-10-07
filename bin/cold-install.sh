#!/bin/sh

sh $(dirname ${0})/destroy-box.sh &&
    sh $(dirname ${0})/destroy-dot-ssh.sh &&
    sh $(dirname ${0})/create-virtual-iso.sh &&
    sh $(dirname ${0})/create-dot-ssh.sh &&
    rm --force ~/.ssh/virtual-install.known_hosts &&
    while [ -z "$(cat build/dot-ssh/install.known_hosts)" ]
    do
	sleep 1s &&
	    ssh-keyscan -p 20560 127.0.0.1 > ~/.ssh/virtual-install.known_hosts
    done &&
    SYMMETRIC_PASSPHRASE=$(uuidgen) &&
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
    sudo VBoxManage startvm --type headless nixos &&
    sleep 1m &&
    echo KEYING IN LUKS PASSWORD &&
    echo "${LUKS_PASSPHRASE}" | keyboardputscancode &&
    echo KEYED IN LUKS PASSWORD &&
    true
