#!/bin/sh

dnf update --assumeyes &&
	dnf install --assumeyes sudo docker &&
	adduser user
