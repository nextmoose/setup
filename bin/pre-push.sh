#!/bin/sh

read LOCAL_REF LOCAL_SHA REMOTE_REF REMOTE_SHA &&
    if [ "${1}" == "upstream" ]
    then
	echo push to upstream branch is not allowed &&
	    exit 64
    elif [ "${1}" == "report" ] && [ -z "${REPORT_BRANCH}" ]
    then
	echo push to unspecified report branch is not allowed &&
	    exit 65
    elif [ "${1}" == "report" ] && [ "REMOTE_REF" != "refs/head/${REPORT_BRANCH}" ]
    then
	echo push to report branch is only allowed for ${REPORT_BRANCH} &&
	    exit 66
    elif [ "${1}" == "report" ] && [ "REMOTE_REF" == "refs/head/${REPORT_BRANCH}" ]
    then
	read -p "Confirmation Requested (Type Upper Case YES):  You are pushing to report ${REPORT_BRANCH}:  " CONFIRMATION &&
	    if [ ! "${CONFIRMATION}" ]
	    then
		echo unconfirmed push to report ${REPORT_BRANCH} &&
		    exit 67
	    fi
    fi
