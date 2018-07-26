#!/bin/sh

dnf update --assumeyes &&
	dnf install --assumeyes sudo &&
	adduser user &&
	echo "#includedir /opt/system/tertiary/sudo" > /etc/sudoers.d/system &&
	echo "user ALL=(ALL) NOPASSWD:SETENV: ALL" > /etc/sudoers.d/breaker &&
	chmod 0444 /etc/sudoers.d/breaker &&
	chmod 0444 /etc/sudoers.d/system &&
	cat /opt/system/primary/bash_profile.txt >> /home/user/.bashrc
