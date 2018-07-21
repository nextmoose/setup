#!/bin/sh

TIMESTAMP=$(date +%s) &&
	keyfile(){
		KEYFILE=$(mktemp /run/keys/XXXXXXXX) &&
			uuidgen > ${KEYFILE} &&
			echo ${KEYFILE}	
	} &&
	mkdir /tmp/containers &&
	cidfile(){
		CIDFILE=$(mktemp /tmp/containers/XXXXXXXX) &&
			rm -f ${CIDFILE} &&
			echo ${CIDFILE}
	} &&
	docker image pull fedora:28 &&
	docker image pull alpine:3.5 &&
	for IMAGE in $(ls -1 /opt/images)
	do
		while ! docker image build --tag local/${IMAGE} /opt/images/${IMAGE}
		do
			echo FAILED TO BUILD IMAGE ${IMAGE} &&
				sleep 10s
		done
	done &&
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
	CRON=$( \
		docker \
		volume \
		create \
		--driver lvm \
		--opt thinpool \
		--opt key=$(keyfile) \
		--label name=cron \
		--label timestamp=${TIMESTAMP} \
	) &&
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
	CRON_CONTAINER=$(cidfile) &&
	docker \
		container \
		create \
		--cidfile ${CRON_CONTAINER} \
		--volume ${CRON}:/var/spool/cron/crontabs:ro \
		local/cron \
		&&
	MAIN=$(docker network create --label timestamp=${TIMESTAMP} $(uuidgen)) &&
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
		--volume ${GPG_SECRETS}:/run/gpg.secrets:ro \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--privileged \
		--label timestamp=\$(date +%s) \
		local/fedora \
		&&
	sudo chown user:user \${CID_FILE} &&
	sudo docker network connect ${MAIN} \$(cat \${CID_FILE}) &&
	sudo docker container start --interactive \$(cat \${CID_FILE}) &&
	true
EOF
	) &&
	chown 1000:1000 /srv/bin/shell &&
	chmod 0500 /srv/bin/shell &&
	docker container start $(ls -1 /tmp/containers | while read CONTAINER
	do
		cat /tmp/containers/${CONTAINER}
	done) &&
	true

