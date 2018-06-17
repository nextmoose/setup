#!/bin/sh

export REGISTRATION_TOKEN=$(uuidgen) &&
    mkdir -p ${HOME}/srv/transient/gitlab/config ${HOME}/srv/transient/gitlab/logs ${HOME}/srv/transient/gitlab/data ${HOME}/srv/permanent/gitlab/backups/application ${HOME}/srv/permanent/gitlab/backups/secrets ${HOME}/srv/transient/gitlab-runner/config &&
    sudo \
	docker \
	container \
	create \
	--hostname gitlab \
	--name gitlab \
	--env GITLAB_OMNIBUS_CONFIG="gitlab_rails['initial_shared_runners_registration_token']='${REGISTRATION_TOKEN}'" \
	--publish 127.0.1.101:20022:22 \
	--publish 127.0.1.101:80:80 \
	--publish 127.0.1.101:443:443 \
	--mount type=bind,source=${HOME}/srv/transient/gitlab/config,destination=/etc/gitlab \
	--mount type=bind,source=${HOME}/srv/transient/gitlab/logs,destination=/var/log/gitlab \
	--mount type=bind,source=${HOME}/srv/transient/gitlab/data,destination=/var/opt/gitlab \
	--mount type=bind,source=${HOME}/srv/permanent/gitlab/backups/application,destination=/var/opt/gitlab/backups \
	gitlab/gitlab-ce:latest &&
    docker \
	container \
	create \
	--name gitlab-runner \
	--mount type=bind,source=${HOME}/srv/transient/gitlab-runner/config,destination=/etc/gitlab-runner \
	--mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
	--env REGISTRATION_TOKEN \
	gitlab/gitlab-runner:latest &&
    docker container start gitlab gitlab-runner &&
    docker network create gitlab &&
    docker network connect --alias gitlab gitlab gitlab &&
    docker network connect gitlab gitlab-runner &&
    seq 0 11 | while read I
    do
	sudo docker container inspect --format "${I} -- {{.State.Health.Status}}" gitlab &&
	    sleep 1m
    done &&
    [ "healthy" == $(docker container inspect --format "{{.State.Health.Status}}" gitlab) ] &&
    BACKUP2=$(sudo ls -1t ${HOME}/srv/permanent/gitlab/backups/application | grep "_gitlab_backup.tar\$" | head -n 1) &&
    if [ ! -z "${BACKUP2}" ]
    then
	BACKUP1=${BACKUP2%_*} &&
	    BACKUP=${BACKUP1%_*} &&
	    echo Restoring BACKUP2=${BACKUP2} BACKUP1=${BACKUP1} BACKUP=${BACKUP} &&
	    (cat | docker container exec --interactive gitlab gitlab-rake gitlab:backup:restore BACKUP=${BACKUP} &&
	    echo ALPHA 001
    fi &&
    echo BETA 001 &&
    docker container exec --interactive --tty gitlab apt-get update --assume-yes &&
    echo BETA 002 &&
    docker container exec --interactive --tty gitlab apt-get install --assume-yes cron &&
    echo BETA 003 &&
    echo "* * * * * nice --adjustment 19 gitlab-rake gitlab:backup:create >> /backup.application.log 2>&1" | docker container exec --interactive gitlab crontab - &&
    echo BETA 004 &&
    docker container exec --interactive --tty gitlab sed -i "s@^session    required   pam_loginuid.so\$@#session    required   pam_loginuid.so@" /etc/pam.d/cron &&
    echo BETA 005 &&
    docker container exec --detach gitlab cron -f &&
    echo BETA 006 &&
    sudo ls -1 ${HOME}/srv/permanent/gitlab/backups/application &&
    sleep 1m &&
    sudo ls -1 ${HOME}/srv/permanent/gitlab/backups/application &&
    sleep 1m &&
    sudo ls -1 ${HOME}/srv/permanent/gitlab/backups/application &&
    sleep 1m &&
    [ "healthy" == $(docker container inspect --format "{{.State.Health.Status}}" gitlab-runner) ] &&
    docker container exec --interactive --tty gitlab-runner bash &&
    docker \
	container \
	exec \
	--interactive \
	--tty \
	gitlab-runner \
	gitlab-runner \
	register \
	--non-interactive \
	--url http://gitlab \
	--registration-token ${REGISTRATION_TOKEN} \
	--executor docker \
	--tag docker \
	--docker-image docker:18.05.0-ce &&
    echo DONE
