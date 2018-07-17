#!/bin/sh

if [ -z "${MASTER_BRANCH}" ]
then
	export MASTER_BRANCH=master 
fi &&
	while [ ${#} -gt 0 ]
	do
		case ${1} in
			--upstream-url)
				export UPSTREAM_URL="${2}" &&
					shift 2
				;;
			--origin-url)
				export ORIGIN_URL="${2}" &&
					shift 2
				;;
			--report-url)
				export REPORT_URL="${2}" &&
					shift 2
				;;
			--committer-name)
				export COMMITTER_NAME="${2}" &&
					shift 2
				;;
			--committer-email)
				export COMMITTER_EMAIL="${2}" &&
					shift 2
				;;
			--master-branch)
				export MASTER_BRANCH="${2}" &&
					shift 2
				;;
			--upstream-host)
				export UPSTREAM_HOST="${2}" &&
					shift 2
				;;
			--upstream-id-rsa)
				export UPSTREAM_ID_RSA="$(pass show ${2})" &&
					shift 2
				;;
			--origin-host)
				export ORIGIN_HOST="${2}" &&
					shift 2
				;;
			--origin-id-rsa)
				export ORIGIN_ID_RSA="$(pass show ${2})" &&
					shift 2
				;;
			--report-host)
				export REPORT_HOST="${2}" &&
					shift 2
				;;
			--report-id-rsa)
				export REPORT_ID_RSA="$(pass show ${2})" &&
					shift 2
				;;
			*)
				echo Unknown Option &&
					echo ${1} &&
					echo ${0} &&
					echo ${@} &&
					exit 64
				;;
		esac
	done &&
	if [ -z "${UPSTREAM_URL}" ]
	then
		echo Unspecified UPSTREAM_URL &&
			exit 65
	elif [ -z "${COMMITTER_NAME}" ]
	then
		echo Unspecified COMMITTER_NAME &&
			exit 66
	elif [ -z "${COMMITTER_EMAIL}" ]
	then
		echo Unspecified COMMITTER_EMAIL &&
			exit 67
	fi &&
	CID_FILE=$(mktemp) &&
	rm ${CID_FILE} &&
	cleanup(){
		docker container stop $(cat ${CID_FILE}) &&
			docker container rm $(cat ${CID_FILE}) &&
			rm -f ${CID_FILE}
	} &&
	# trap cleanup EXIT &&
	docker \
		container \
		create \
		--cidfile ${CID_FILE} \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--env DISPLAY \
		--env UPSTREAM_URL \
		--env ORIGIN_URL \
		--env REPORT_URL \
		--env COMMITTER_NAME \
		--env COMMITTER_EMAIL \
		--env MASTER_BRANCH \
		--env UPSTREAM_HOST \
		--env UPSTREAM_ID_RSA \
		--env ORIGIN_HOST \
		--env ORIGIN_ID_RSA \
		--env REPORT_HOST \
		--env REPORT_ID_RSA \
		--volume $(docker volume create --driver lvm --opt thinpool --opt size=1G):/usr/local/src \
		local/emacs \
		&&
	docker \
		container \
		start \
		$(cat ${CID_FILE}) \
		&&
	true
