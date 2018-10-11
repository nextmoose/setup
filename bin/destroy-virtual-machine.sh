#!/bin/sh

if [ "$(sudo VBoxManage showvminfo nixos)" ]
then
    if [ "0" != "$(sudo VBoxManage showvminfo nixos | grep -c running)" ]
    then
	sudo VBoxManage controlvm nixos poweroff soft &&
	    sleep 10s
    fi &&
	if [ "0" != "$(sudo VBoxManage list vms | grep -c nixos)" ]
	then
	    sudo VBoxManage unregistervm --delete nixos &&
		sleep 10s
	fi
fi &&
    if [ "0" != "$(sudo lvs | grep -c nixos)" ]
    then
	sudo lvremove --force /dev/volumes/nixos
    fi &&
    if [ "0" != "$(sudo lvs | grep -c config)" ]
    then
	if [ -d build/config ]
	then
	    sudo umount build/config &&
		rm --recursive --force build/config
	fi &&
	sudo lvremove --force /dev/volumes/config
    fi &&
    rm --force build/nixos.vmdk &&
    rm --recursive --force build/src &&
    rm --recursive --force build &&
    true
