#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    STATUS=FAIL &&
    cleanup() {
	echo ${STATUS} &&
	    echo ${WORK_DIR}
    } &&
    trap cleanup EXIT &&
    mkdir ${WORK_DIR}/.ssh &&
    ssh-keygen -f ${WORK_DIR}/.ssh/id_rsa -P "" -C "" &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/.ssh/id_rsa)#" \
	-e "w${WORK_DIR}/iso.nix" \
	iso.nix.template &&
    mkdir ${WORK_DIR}/installer &&
    cp installer.nix ${WORK_DIR}/installer/default.nix &&
    mkdir ${WORK_DIR}/installer/src &&
    cp installer.sh ${WORK_DIR}/installer/src/installer.sh &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/.ssh/id_rsa)#" \
	-e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
	-e "w${WORK_DIR}/installer/src/configuration.nix" \
	configuration.nix.template &&
    cp -r custom ${WORK_DIR}/installer/src/custom &&
    (
	cd ${WORK_DIR}
	time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    VBoxManage list vms | grep nixos | while read VM
    do
	VBoxManage controlvm nixos poweroff soft &&
	    VBoxManage unregistervm --delete nixos
    done &&
    sudo lvs | grep nixos | while read VOL
    do
	sudo lvremove --force /dev/volumes/nixos
    done &&
    (
	sudo lvcreate -y --name nixos --size 100GB volumes &&
	    VBoxManage internalcommands createrawvmdk -filename nixos -rawdisk /dev/volumes/nixos &&
	    VBoxManage createvm --name nixos --groups /nixos --register &&
	    VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
	    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium ${WORK_DIR}/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
	    VBoxManage storagectl ${VM} --name "IDE" --add IDE &&
	    VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium ${VMDK} &&
	    VBoxManage modifyvm nixos --natpf1 "guestssh1,tcp,127.0.0.1,${PORT1},,22" &&
	    VBoxManage modifyvm nixos --nic1 nat &&
	    VBoxManage modifyvm nixos --memory 2000 &&
	    VBoxManage modifyvm nixos --firmware efi &&
    ) &&
    STATUS=PASS &&
    true
