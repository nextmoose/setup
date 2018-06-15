#!/bin/sh

mkdir -p ${HOME}/srv/transient/gitlab/config ${HOME}/srv/transient/gitlab/logs ${HOME}/srv/transient/gitlab/data ${HOME}/srv/permanent/gitlab/backup/application ${HOME}/srv/permanent/gitlab/backup/secrets &&
    docker \
	container \
	create \
	--name gitlab \
	--publish 127.0.1.100:20022:22 \
	--publish 127.0.1.100:20080:80 \
	--publish 127.0.1.100:20443:443 \
	--mount type=bind,source=${HOME}/srv/transient/gitlab/config,destination=/etc/gitlab \
	--mount type=bind,source=${HOME}/srv/transient/gitlab/logs,destination=/var/log/gitlab \
	--mount type=bind,source=${HOME}/srv/transient/gitlab/data,destination=/var/opt/gitlab \
	--mount type=bind,source=${HOME}/srv/permanent/gitlab/backup/application,destination=/var/opt/gitlab/backup \
	gitlab/gitlab-ce:latest &&
    docker container start gitlab &&
    wait_for_healthy(){
	docker events --filter "container=gitlab" --filter event="health_status: healthy" | while read EVENT
	do
	    echo WE ARE IN THE LOOP &&
	    if [ "healthy" == $(docker container inspect --format "{{.State.Health.Status}}" gitlab) ]
	    then
		echo The gitlab container is healthy. &&
		    return 0
	    else
		echo The gitlab container is not healthy. &&
		    exit 64
	    fi
	done
    } &&
    wait_for_healthy &&
    echo WE ESCAPED THE LOOP &&
    BACKUP2=$(sudo ls -1t ${HOME}/srv/permanent/gitlab/backup/application | head -n 1) &&
    if [ ! -z "${BACKUP2}" ]
    then
	BACKUP1=${BACKUP2%_*} &&
	    BACKUP=${BACKUP1%_*} &&
	    echo Restoring ${BACKUP} &&
	    docker container exec --interactive --tty gitlab bash -c "BACKUP=${BACKUP} bash"
    fi &&
    echo yes | docker container exec --interactive gitlab gitlab-rake gitlab:backup:restore BACKUP=${BACKUP} &&
    docker container exec --interactive --tty gitlab apt-get update --assume-yes &&
    docker container exec --interactive --tty gitlab apt-get install --assume-yes cron &&
    FILE=$(docker container exec --interactive --tty gitlab mktemp) &&
    echo "* * * * * nice --adjustment 19 gitlab-rake gitlab:backup:create >> /backup.application.log 2>&1" | docker container exec --interactive gitlab crontab - &&
    docker container exec --detach gitlab crontab -f &&
    sleep 1m &&
    sudo ls -1 ${HOME}/srv/permanent/gitlab/backup/application &&
    sleep 1m &&
    sudo ls -1 ${HOME}/srv/permanent/gitlab/backup/application
