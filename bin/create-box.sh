#!/bin/sh

if [ ! -d build ]
then
    mkdir build
fi &&
    if [ ! -d build/box ]
    then
	mkdir build/box
    fi &&
    if [ "0" == "$(sudo lvs | grep -c nixos)" ]
    then
	sudo lvcreate -y --name nixos --size 100GB volumes
    fi &&
    if [ ! -f build/box/nixos.vmdk ]
    then
	sudo VBoxManage internalcommands createrawvmdk -filename build/box/nixos.vmdk -rawdisk /dev/volumes/nixos
    fi &&
    VBoxManage createvm --name nixos --groups /nixos --register &&
    VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium build/virtual/result/iso/$(ls -1 build/virtual/result/iso) &&
    VBoxManage storagectl nixos --name "IDE" --add IDE &&
    VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium build/box/nixos.vmdk &&
    VBoxManage modifyvm nixos --natpf1 "install,tcp,127.0.0.1,20560,,22" &&
    VBoxManage modifyvm nixos --natpf1 "use,tcp,127.0.0.1,29156,,22" &&
    VBoxManage modifyvm nixos --nic1 nat &&
    VBoxManage modifyvm nixos --nic2 bridged &&
    VBoxManage modifyvm nixos --bridgeadapter2 wlo1 &&
    VBoxManage modifyvm nixos --memory 2000 &&
    VBoxManage modifyvm nixos --firmware efi
