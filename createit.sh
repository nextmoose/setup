#!/bin/sh

VBoxManage \
    createvm \
    --name nixos \
    --groups /nixos \
    --register &&
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix &&
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
    sudo lvcreate --name nixos --size 100GB volumes &&
    sudo VBoxManage internalcommands createrawvmdk -filename  $(pwd)/nixos.vmdk -rawdisk /dev/volumes/nixos &&
    sudo chmod a+rwx nixos.vmdk &&
    VBoxManage \
	storageattach \
	nixos \
	--storagectl "IDE" \
	--port 0 \
	--device 0 \
	--type hdd \
	--medium $(pwd)/nixos.vmdk &&
    VBoxManage startvm nixos &&
    echo HELLO WORLD &&
    true
