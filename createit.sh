#!/bin/sh

export PORT=27895 &&
    if [ ! -d work ]
    then
	mkdir work
    fi &&
    if [ ! -d work/.ssh ]
    then
	mkdir work/.ssh &&
	    chmod 0700 work/.ssh
    fi &&
    if [ ! -f work/.ssh/config ]
    then
	(cat > work/.ssh/config <<EOF
Host nixos
HostName 127.0.0.1
User user
Port ${PORT}
IdentityFile ~/.ssh/user.id_rsa
UserKnownHostsFile ~/.ssh/known_hosts
EOF
	) &&
	    chmod 0400 work/.ssh/config
    fi &&
    if [ ! -f work/.ssh/host.id_rsa ]
    then
	ssh-keygen -f work/.ssh/host.id_rsa -P "" -C "" &&
	    chmod 0400 work/.ssh/host.id_rsa &&
	    rm -f work/.ssh/host.id_rsa.pub
    fi &&
    if [ ! -f work/.ssh/known_hosts ]
    then
	ssh-keygen -y -f work.ssh/host.id_rsa > work/.ssh/known_hosts &&
	    chmod 0400 work/.ssh/known_hosts
    fi &&
    if [ ! -f work/.ssh/user.id_rsa ]
    then
	ssh-keygen -f work/.ssh/user.id_rsa -P "" -C "" &&
	    chmod 0400 work/.ssh/user.id_rsa &&
	    rm -f work/.ssh/user.id_rsa
    fi &&
    if [ ! -f work/.ssh/known_hosts ]
    then
	
    fi


EE=$(date +%s) &&
    VM=nixos &&
    SSH_KEY=id_rsa &&
    VMDK=$(mktemp) &&
    ISONIX=$(mktemp $(pwd)/XXXXXXXX) &&
    PORT1=27895 &&
    KNOWN_HOSTS1=$(mktemp) &&
    KNOWN_HOSTS2=$(mktemp) &&
    NAP=1s &&
    rm -f ${SSH_KEY} ${VMDK} &&
    cleanup(){
	echo CLEANING UP &&
	    VBoxManage controlvm ${VM} poweroff soft &&
	    sleep ${NAP} &&
	    VBoxManage unregistervm --delete ${VM} &&
	    sudo lvremove --force /dev/volumes/${VM} &&
	    rm -f ${ISONIX} ${KNOWN_HOSTS1} ${KNOWN_HOSTS2} &&
	    FF=$(date +%s) &&
	    echo TOTAL EXECUTION TIME=$((${FF}-${EE})) seconds. &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ ! -f ${SSH_KEY} ]
    then
	ssh-keygen -f ${SSH_KEY} -P "" -C ""
    fi &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f id_rsa)#" \
	-e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
	-e "w${ISONIX}" \
	iso.nix &&
    sed \
	-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f id_rsa)#" \
	-e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
	-e "wcustom/my-install/src/configuration.2.nix" \
	custom/my-install/src/configuration.nix &&
    AA=$(date +%s) &&
    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=${ISONIX} &&
    BB=$(date +%s) &&
    sudo lvcreate -y --name ${VM} --size 100GB volumes &&
    VBoxManage \
	internalcommands \
	createrawvmdk -filename  \
	${VMDK} \
	-rawdisk /dev/volumes/${VM} &&
    VBoxManage \
	createvm \
	--name ${VM} \
	--groups /nixos \
	--register &&
    VBoxManage storagectl ${VM} --name "SATA Controller" --add SATA &&
    VBoxManage \
	storageattach \
	${VM} \
	--storagectl "SATA Controller" \
	--port 0 \
	--device 0 \
	--type dvddrive \
	--medium $(pwd)/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
    VBoxManage storagectl ${VM} --name "IDE" --add IDE &&
    VBoxManage \
	storageattach \
	${VM} \
	--storagectl "IDE" \
	--port 0 \
	--device 0 \
	--type hdd \
	--medium ${VMDK} &&
    VBoxManage modifyvm "${VM}" --natpf1 "guestssh1,tcp,127.0.0.1,${PORT1},,22" &&
    VBoxManage modifyvm "${VM}" --nic1 nat &&
    VBoxManage modifyvm "${VM}" --memory 2000 &&
    VBoxManage modifyvm "${VM}" --firmware efi &&
    echo SSH KEY=${SSH_KEY} &&
    echo PORT1=${PORT1} &&
    VBoxManage startvm --type headless ${VM} &&
    echo ${KNOWN_HOSTS1} &&
    sleep ${NAP} &&
    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS1} &&
    while [ -z "$(cat ${KNOWN_HOSTS1})" ]
    do
	echo waiting for keyscan &&
	    sleep ${NAP} &&
	    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS1} &&
	    sleep ${NAP}
    done &&
    echo waited for keyscan &&
    echo finished waiting for vm &&
    CC=$(date +%s) &&
    time ssh -i ${SSH_KEY} -l root -p ${PORT1} -o UserKnownHostsFile=${KNOWN_HOSTS1} 127.0.0.1 my-install &&
    DD=$(date +%s) &&
    echo INSTALLED ... NOW POWER OFF &&
    VBoxManage controlvm ${VM} poweroff soft &&
    echo INSTALLED ... NOW POWERED OFF &&
    sleep ${NAP} &&
    echo ABOUT TO REMOVE DISK &&
    VBoxManage storageattach ${VM} --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
    echo REMOVED DISK &&
    VBoxManage startvm --type headless ${VM} &&
    echo ${KNOWN_HOSTS2} &&
    sleep ${NAP} &&
    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS2} &&
    while [ -z "$(cat ${KNOWN_HOSTS2})" ]
    do
	echo waiting for keyscan &&
	    sleep ${NAP} &&
	    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS2} &&
	    sleep ${NAP}
    done &&
    echo waited for keyscan &&
    test_it() {
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--title)
		    TITLE="${2}" &&
			shift 2
		    ;;
		--expected-exit-code)
		    EXPECTED_EXIT_CODE="${2}" &&
			shift 2
		    ;;
		--expected-output)
		    EXPECTED_OUTPUT="${2}" &&
			shift 2
		    ;;
		--command)
		    COMMAND="${2}" &&
			shift 2
		    ;;
		*)
		    echo Unexpected Argument &&
			echo ${@} &&
			exit 65
		    ;;
	    esac
	done &&
	    echo TITLE=${TITLE} &&
	    echo COMMAND=${COMMAND} &&
	    echo EXPECTED_OUTPUT=${EXPECTED_OUTPUT} &&
	    echo EXPECTED_EXIT_CODE=${EXPECTED_EXIT_CODE} &&
	    BEFORE=$(date +%s) &&
	    echo ssh -i ${SSH_KEY} -l user -p ${PORT1} -o UserKnownHostsFile=${KNOWN_HOSTS2} 127.0.0.1 '${COMMAND}' &&
	    OBSERVED_OUTPUT="$(ssh -i ${SSH_KEY} -l user -p ${PORT1} -o UserKnownHostsFile=${KNOWN_HOSTS2} 127.0.0.1 \"${COMMAND}\")" &&
	    OBSERVED_EXIT_CODE=${?} &&
	    AFTER=$(date +%s) &&
	    echo DURATION=$((${AFTER}-${BEFORE})) &&
	    echo OBSERVED_OUTPUT=${OBSERVED_OUTPUT} &&
	    echo OBSERVED_EXIT_CODE=${OBSERVED_EXIT_CODE} &&
	    if [ "${OBSERVED_EXIT_CODE}" != "${EXPECTED_EXIT_CODE}" ]
	    then
		echo Unexpected exit code &&
		    exit 66
	    elif [ "${OBSERVED_OUTPUT}" != "${EXPECTED_OUTPUT}" ]
	    then
		echo Unexpected output &&
		    exit 67
	    else
		echo SUCCESS
	    fi
    } &&
    test_it --title "We have a secrets program." --expected-output hello --expected-exit-code 0 --command secrets &&
    echo PASSED ALL TESTS &&
    echo TIME TO BUILD ISO IMAGE = $((${BB}-${AA})) seconds. &&
    echo TIME TO RUN INSTALL PROGRAM = $((${DD}-${CC})) seconds. &&
    true
