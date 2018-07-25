#!/bin/sh

if [ -f /opt/system/secondary/cleanup.user.sh ]
then
	cleanup(){
		sh /opt/system/secondary/cleanup.user.sh
	} &&
		trap cleanup EXIT
fi &&
	if [ -f /opt/system/secondary/init.user.sh ]
	then
		sh /opt/system/secondary/init.user.sh
	fi &&
	if [ -f /opt/system/secondar/post.user.sh ]
	then
		nohup sh /opt/system/secondary/post.user.sh &
	fi &&
	if [ -d /opt/system/tertiary/completion ]
	then
		for COMPLETION in $(ls -1 /opt/system/tertiary/completion)
		do
			source /opt/system/tertiary/completion/${COMPLETION}
		done
	fi &&
	cd /home/user &&
	export PATH=${PATH}:/opt/system/tertiary/bin &&
	bash
