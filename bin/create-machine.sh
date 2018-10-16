#!/bin/sh

sudo VBoxManage createvm --name nixos --register &&
    sudo VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium emptydrive &&
    sudo VBoxManage storagectl nixos --name "IDE" --add IDE &&
    sudo lvcreate -y --name nixos --size 100G volumes &&
    sudo VBoxManage internalcommands createrawvmdk -filename build/nixos.vmdk -rawdisk /dev/volumes/nixos &&
    sudo VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium build/nixos.vmdk &&
    sudo VBoxManage modifyvm nixos --memory 2000 &&
    sudo VBoxManage modifyvm nixos --nic1 nat &&
    true
