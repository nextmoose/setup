#!/bin/sh

read LOCAL_REF LOCAL_SHA REMOTE_REF REMOTE_SHA &&
    if [ "${1}" == "upstream" ]
    then
	echo push to upstream branch is not allowed &&
	    exit 64
    elif [ "${1}" == "report" ] && [ "REMOTE_REF" != "refs/head/${REPORT_BRANCH}" ]
    then
	echo push to report branch is only allowed for ${REPORT_BRANCH} &&
	    exit 65
    fi
