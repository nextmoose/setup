#!/bin/sh

cleanup(){
    VBoxManage list vms | cut --fields 2 --delimiter '"' | while read VM
    do
	VBoxManage controlvm ${VM} poweroff soft &&
	    VBoxManage unregistervm --delete ${VM}
    done &&
	sudo lvremove --force /dev/volumes/nixos &&
	true
} &&
    trap cleanup EXIT &&
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix &&
    sudo lvcreate --name nixos --size 100GB volumes &&
    VBoxManage \
	internalcommands \
	createrawvmdk -filename  \
	$(pwd)/nixos.vmdk \
	-rawdisk /dev/volumes/nixos &&
    VBoxManage \
	createvm \
	--name nixos \
	--groups /nixos \
	--register &&
    VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
    VBoxManage \
	storageattach \
	nixos \
	--storagectl "SATA Controller" \
	--port 0 \
	--device 0 \
	--type dvddrive \
	--medium $(pwd)/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
    VBoxManage storagectl nixos --name "IDE" --add IDE &&
    VBoxManage \
	storageattach \
	nixos \
	--storagectl "IDE" \
	--port 0 \
	--device 0 \
	--type hdd \
	--medium $(pwd)/nixos.vmdk &&
    VBoxManage startvm nixos &&
    sleep 2m &&
    ssh -i id_rsa -l root 64.137.201.46 hello &&
    echo SUCCESS &&
    sleep 5m &&
    true
