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
    VBoxManage \
	storageattach \
	nixos \
	--storagectl "IDE" \
	--port 0 \
	--device 0 \
	--type hdd \
	--medium $(pwd)/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&    
    true
