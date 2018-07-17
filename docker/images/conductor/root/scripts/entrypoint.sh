#!/bin/sh

TIMESTAMP=$(date +%s) &&
	keyfile(){
		KEYFILE=$(mktemp /run/keys/XXXXXXXX) &&
			uuidgen > ${KEYFILE} &&
			echo ${KEYFILE}	
	} &&
	docker image pull fedora:28 &&
	docker image pull alpine:3.5 &&
	HOMEY=$( \
		docker \
		volume \
		create \
		--driver lvm \
		--opt thinpool \
		--opt size=8G \
		--opt key=$(keyfile) \
		--label name=home \
		--label timestamp=${TIMESTAMP} \
		) \
		&&
	GPG_SECRETS=$( \
		docker \
		volume \
		create \
		--driver lvm \
		--opt thinpool \
		--opt size=8G \
		--opt key=$(keyfile) \
		--label name=root \
		--label timestamp=${TIMESTAMP} \
		) \
		&&
	SCRIPTS=$( \
		docker \
		volume \
		create \
		--driver lvm \
		--opt thinpool \
		--opt size=1G \
		--label name=scripts \
		--label timestamp=${TIMESTAMP} \
		) \
		&&
	SUDOERS=$( \
		docker \
		volume \
		create \
		--driver lvm \
		--opt thinpool \
		--opt size=1G \
		--label name=sudoers \
		--label timestamp=${TIMESTAMP} \
		) \
		&&
	MAIN=$(docker network create --label name=main --label timestamp=${TIMESTAMP} $(uuidgen)) &&	
	cat /gpg.secret.key | docker \
		container \
		run \
		--interactive \
		--rm \
		--volume ${GPG_SECRETS}:/output \
		alpine:3.5 \
		tee /output/gpg.secret.key \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${GPG_SECRETS}:/output \
		alpine:3.5 \
		chmod 0400 /output/gpg.secret.key \
		&&
	cat /gpg.owner.trust | docker \
		container \
		run \
		--interactive \
		--rm \
		--volume ${GPG_SECRETS}:/output \
		alpine:3.5 \
		tee /output/gpg.owner.trust \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${GPG_SECRETS}:/output \
		alpine:3.5 \
		chmod 0400 /output/gpg.owner.trust \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${SCRIPTS}:/output \
		alpine:3.5 \
		mkdir /output/bin \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${SCRIPTS}:/output \
		alpine:3.5 \
		chmod 0555 /output/bin \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${SCRIPTS}:/output \
		alpine:3.5 \
		mkdir /output/sbin \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${SCRIPTS}:/output \
		alpine:3.5 \
		chmod 0500 /output/sbin \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${SCRIPTS}:/output \
		alpine:3.5 \
		mkdir /output/completion \
		&&
	docker \
		container \
		run \
		--interactive \
		--tty \
		--rm \
		--volume ${SCRIPTS}:/output \
		alpine:3.5 \
		chmod 0555 /output/completion \
		&&
	for SCRIPT in $(ls -1 /opt/scripts/sbin)
	do
		(cat <<EOF
#!/bin/sh

while [ \${1} -gt 0 ]
do
	case \${1} in
EOF
		) | docker \
			container \
			run \
			--interactive \
			--rm \
			--volume ${SCRIPTS}:/output \
			alpine:3.5 \
			tee /output/sbin/${SCRIPT} \
			&&
                        cat /opt/scripts/config/${SCRIPT%.*}.csv | while read LINE
                        do
				SWITCH=$(echo ${LINE} | cut -f 1 -d " ") &&
					VARIABLE=$(echo ${LINE} | cut -f 2 -d " ") &&
					case $(echo ${LINE} | cut -f 3 -d " ") in
						string)
							VALUE="\${2}"
							;;
						secret)
							VALUE="\$(pass show \${2}"
							;;
						*)
							echo Unknown Type &&
								exit 65
					esac &&
                                	echo -e "\t\t--${SWITCH}) export ${VARIABLE}=\"${VALUE}\" && shift 2 ;;"
                        done | docker \
                                container \
                                run \
                                --interactive \
                                --rm \
                                --volume ${SCRIPTS}:/output \
                                alpine:3.5 \
                                tee -a /output/sbin/${SCRIPT} \
                                alpine:3.5 \
                                tee -a /output/sbin/${SCRIPT} \
                                &&
			(cat <<EOF
		*) echo Unknown Option && echo ${1} && echo ${0} && echo ${@} && exit 64 ;;
	esac
done &&
	
EOF
			) | docker \
				container \
				run \
				--interactive \
				--rm \
				--volume ${SCRIPTS}:/output \
				alpine:3.5 \
				tee -a /output/sbin/${SCRIPT} \
				&&
			tail -n +3 /opt/scripts/sbin/${SCRIPT} | docker \
				container \
				run \
				--interactive \
				--rm \
				--volume ${SCRIPTS}:/output \
				alpine:3.5 \
				tee -a /output/sbin/${SCRIPT} \
				&&
			docker \
				container \
				run \
				--interactive \
				--rm \
				--volume ${SCRIPTS}:/output \
				alpine:3.5 \
				chmod 0500 /output/sbin/${SCRIPT} \
				&&
			(cat <<EOF
#!/bin/sh

sudo --preserve-env /opt/root/scripts/sbin/${SCRIPT} "\${@}"
EOF
			) | docker \
				container \
				run \
				--interactive \
				--rm \
				--volume ${SCRIPTS}:/output \
				alpine:3.5 \
				tee /output/bin/${SCRIPT%.*} \
			 	&&
			docker \
				container \
				run \
				--interactive \
				--tty \
				--rm \
				--volume ${SCRIPTS}:/output \
				alpine:3.5 \
				chmod 0555 /output/bin/${SCRIPT%.*} \
				&&
			(cat <<EOF
#!/bin/sh

_UseGetOpt_${SCRIPT%.*}(){
	local CUR &&
		COMPREPLY=() &&
		CUR=\${COMP_WORDS[COMP_CWORD]} &&
		case \${CUR} in
			*) COMPREPLY=(\$(compgen -W "$(cut -f1 -d \" \" /opt/scripts/completion/scripts))) ;;
		esac
} &&
	complete -o ${SCRIPT%.*} _UseGetOpt_${SCRIPT%.*}
EOF
			) | docker \
				container \
				run \
				--interactive \
				--rm \
				--volume ${SCRIPTS}:/output \
				alpine:3.5 \
				tee /output/completion/${SCRIPT} \
				&&
			docker \
				container \
				run \
				--interactive \
				--tty \
				--volume ${SCRIPTS}:/output \
				alpine:3.5 \
				chmod 0555 /output/completion/${SCRIPT} \
				&&
			echo user "ALL=(ALL) SETENV:NOPASSWD:/opt/root/scripts/sbin/${SCRIPT}" | docker \
				container \
				run \
				--interactive \
				--rm \
				--volume ${SUDOERS}:/output \
				alpine:3.5 \
				tee /output/${SCRIPT%.*} \
				&&
			docker \
				container \
				run \
				--interactive \
				--rm \
				--volume ${SUDOERS}:/output \
				alpine:3.5 \
				chmod 0444 /output/${SCRIPT%.*} \
				&&
			true
	done &&
	(cat > /srv/bin/shell <<EOF
#!/bin/sh

CID_FILE=\$(mktemp) &&
	rm \${CID_FILE} &&
	cleanup(){
		rm -f \${CID_FILE}
	} && 
	sudo \
		docker \
		container \
		create \
		--cidfile \${CID_FILE} \
		--interactive \
		--tty \
		--rm \
		--env DISPLAY \
		--volume ${HOMEY}:/home \
		--volume ${SCRIPTS}:/opt/root/scripts:ro \
		--volume ${SUDOERS}:/etc/sudoers.d:ro \
		--volume ${GPG_SECRETS}:/run/gpg.secrets:ro \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--privileged \
		local/fedora \
		&&
	sudo chown user:user \${CID_FILE} &&
	sudo docker network connect ${MAIN} \$(cat \${CID_FILE}) &&
	sudo docker container start --interactive \$(cat \${CID_FILE}) &&
	true
EOF
	) &&
	chown 1000:1000 /srv/bin/shell &&
	chmod 0500 /srv/bin/shell

