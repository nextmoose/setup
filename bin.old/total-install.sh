#!/bin/sh

sh $(dirname ${0})/create-real-iso.sh &&
    ls -1 build/real/result/iso | while read FILE
    do
	cp build/real/result/iso/${FILE} /dev/sdb
    done &&
    reboot
