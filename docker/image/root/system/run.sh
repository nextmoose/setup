#!/bin/sh

apk update &&
	apk upgrade &&
	apk add --no-cache util-linux &&
	rm -rf /var/cache/apk/*
