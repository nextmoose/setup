#!/bin/sh

if [ ! -d build ]
then
    mkdir build
fi &&
    sh $(dirname ${0})/destroy-virtual-machine.sh &&
    sh $(dirname ${0})/create-install-iso.sh &&
    sudo lvcreate -y --name nixos --size 100GB volumes &&
    sudo VBoxManage internalcommands createrawvmdk -filename build/nixos.vmdk -rawdisk /dev/volumes/nixos &&
    sudo VBoxManage createvm --name nixos --groups /nixos --register &&
    sudo VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
    ls -1 build/src/result/iso | while read FILE
    do
	sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium build/src/result/iso/${FILE}
    done &&
    sudo VBoxManage storagectl nixos --name "IDE" --add IDE &&
    sudo VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium build/nixos.vmdk &&
#    sudo VBoxManage modifyvm nixos --nic1 bridged &&
#    sudo VBoxManage modifyvm nixos --bridgeadapter1 wlo1 &&
    sudo VBoxManage modifyvm nixos --memory 2000 &&
    sudo VBoxManage modifyvm nixos --firmware efi
    true
