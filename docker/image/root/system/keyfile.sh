#!/bin/sh

KEY_FILE=$(mktemp /run/keys/XXXXXXXX) &&
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 1024 | head -n 1 > ${KEY_FILE} &&
	echo ${KEY_FILE}
