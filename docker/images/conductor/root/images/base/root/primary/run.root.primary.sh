#!/bin/sh

dnf update --assumeyes &&
	dnf install --assumeyes sudo &&
	adduser user &&
	echo "#includedir /opt/system/tertiary/sudo" > /etc/sudoers.d/system &&
	chmod 0444 /etc/sudoers.d/system
