#!/bin/sh

if [ -f /opt/system/secondary/cleanup.root.sh ]
then
	cleanup() {
		sh /opt/system/secondary/cleanup.root.sh
	} &&
		trap cleanup EXIT
fi &&
	if [ -f /opt/system/secondary/parse.sh ]
	then
		sh /opt/system/secondary.parse.sh "${@}"
	fi &&
	if [ -f /opt/system/secondary/init.root.sh ]
	then
		sh /opt/system/secondary/init.root.sh ]
	fi &&
	if [ -f /opt/system/secondary/post.root.sh ]
	then
		nohup sh /opt/system/secondary/post.root.sh &
	fi &&
	bash &&
	echo su -c "sh /opt/system/primary/entrypoint.user.sh" user
