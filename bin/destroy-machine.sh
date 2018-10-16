#!/bin/sh

sudo VBoxManage unregistervm --delete nixos &&
    sudo lvremove --force /dev/volumes/nixos &&
    sudo rm --force build/nixos.vmdk &&
    true
