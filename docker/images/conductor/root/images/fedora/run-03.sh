#!/bin/sh

echo "#includedir /opt/system/sudo" > /etc/sudoers.d/system &&
	chmod 0444 /etc/sudoers.d/system &&
	dnf install --assumeyes pass gpg
