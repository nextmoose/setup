#!/bin/sh

rm --recursive --force build/transfer &&
    sh $(dirname ${0})/create-configuration.sh &&
    mkdir build/transfer &&
    cp --recursive build/configuration/custom/installer/src/ build/transfer/configuration &&
    cp build/configuration/custom/installer/src/configuration.nix build/transfer/configuration &&
    cp --recursive src/testing/bin build/transfer/bin &&
    mkisofs -lJR -o build/transfer.iso build/transfer &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium build/transfer.iso &&
    sh $(dirname ${0})/boot-machine.sh &&
    echo sudo | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo mkdir | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo -p | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo /mnt | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo "&&" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo sudo | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo mount | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo /dev/cdrom | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo /mnt | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    echo "&&" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    echo sh | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo /mnt/bin/update-configuration.sh | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-space.sh &&
    echo "&&" | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    echo true | sh $(dirname ${0})/transcribe-keyboard-alpha.sh &&
    sh $(dirname ${0})/type-keyboard-enter.sh &&
    true
