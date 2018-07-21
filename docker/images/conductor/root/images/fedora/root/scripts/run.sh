#!/bin/sh

dnf update --assumeyes &&
	dnf install --assumeyes git pass gnupg sudo &&
	adduser user &&
	mkdir /opt/stuff &&
	dnf clean all &&
	true
