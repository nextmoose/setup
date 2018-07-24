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
	export PATH=${PATH}:/opt/system/tertiary/bin &&
	bash
