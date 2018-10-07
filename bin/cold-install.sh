#!/bin/sh

sh $(dirname ${0})/destroy-box.sh &&
    sh $(dirname ${0})/destroy-dot-ssh.sh &&
    sh $(dirname ${0})/create-virtual-iso.sh &&
    rm --force ~/.ssh/virtual-install.known_hosts &&
    while [ -z "$(cat build/dot-ssh/install.known_hosts)" ]
    do
	sleep 1s &&
	    ssh-keyscan -p 20560 127.0.0.1 > ~/.ssh/virtual-install.known_hosts
    done
(cat <<EOF
${VIRTUAL_SYMMETRIC_PASSPHRASE}
${VIRTUAL_SYMMETRIC_PASSPHRASE}
${VIRTUAL_LUKS_PASSPHRASE}
${VIRTUAL_LUKS_PASSPHRASE}
EOF
) | time ssh -F ${WORK_DIR}/virtual/.ssh/config alpha installer --no-shutdown --no-volumes &&
    sudo VBoxManage controlvm nixos poweroff soft &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
    true
