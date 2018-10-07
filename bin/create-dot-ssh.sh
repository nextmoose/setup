#!/bin/sh

if [ ! -d build ]
then
    mkdir build
fi &&
    if [ ! -d build/dot-ssh ]
    then
	mkdir build/dot-ssh
    fi &&
    if [ ! -f build/dot-ssh/config ]
    then
	(cat > build/dot-ssh/config <<EOF
Host installer
HostName 127.0.0.1
User root
Port 20560
IdentityFile $(pwd)/build/dot-ssh/installer.id_rsa
UserKnownHostsFile $(pwd)/build/dot-ssh/installer.known_hosts

Host use
HostName 127.0.0.1
User root
Port 29156
IdentityFile $(pwd)/build/dot-ssh/use.id_rsa
UserKnownHostsFile $(pwd)/build/dot-ssh/use.known_hosts
EOF
	) &&
	    chmod 0600 build/dot-ssh/config
    fi &&
    if [ ! -f build/dot-ssh/installer.id_rsa ]
    then
	ssh-keygen -f build/dot-ssh/installer.id_rsa -P "" -C "" &&
	    rm --force build/dot-ssh/installer.id_rsa.pub
    fi &&
    if [ ! -f build/dot-ssh/use.id_rsa ]
    then
	ssh-keygen -f build/dot-ssh/use.id_rsa -P "" -C "" &&
	    rm --force build/dot-ssh/use.id_rsa.pub
    fi &&
    true
