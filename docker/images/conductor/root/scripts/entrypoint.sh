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
	MAIN=$(docker network create --label timestamp=${TIMESTAMP} $(uuidgen)) &&
	echo AAAAAAAAAAAAAAAA &&
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
	echo BBBBBBBBBBBBBBBBBBB &&
	chown 1000:1000 /srv/bin/shell &&
	chmod 0500 /srv/bin/shell &&
	echo CCCCCCCCCCCCCCCCCCCCCC &&
	true

