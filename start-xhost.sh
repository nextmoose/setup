#!/bin/sh

sudo sed -i "s#^exit 0\$#/usr/bin/xhost +local:#" /etc/gdm/Init/Default &&
    echo exit 0 | sudo tee --append /etc/gdm/Init/Default &&
    /usr/bin/xhost +local: &&
    true