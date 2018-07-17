#!/bin/sh

declare PACKAGES &&
	while [ ${#} -gt 0 ]
	do
		case ${1} in
			--package)
				PACKAGES+=${2} &&
					shift 2
				;;
			--entrypoint)
				ENTRYPOINT=${2} &&
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
	WORK_DIR=$(mktemp -d) &&
	(cat > ${WORK_DIR}/Dockerfile <<EOF
FROM fedora:28
RUN echo hi
RUN dnf update --assumeyes 
USER user
ENTRYPOINT ["sh", "${ENTRYPOINT}"]
CMD []
EOF
	) &&
	IMAGE_TAG=local/$(uuidgen) &&
	cat ${WORK_DIR}/Dockerfile &&
	sudo docker build --tag ${IMAGE_TAG} ${WORK_DIR} &&
	echo ${IMAGE_TAG}
