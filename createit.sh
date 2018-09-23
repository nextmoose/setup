#!/bin/sh

VM=nixos &&
    SSH_KEY=id_rsa &&
    VMDK=$(mktemp) &&
    ISONIX=$(mktemp $(pwd)/XXXXXXXX) &&
    PORT1=27895 &&
    KNOWN_HOSTS1=$(mktemp) &&
    KNOWN_HOSTS2=$(mktemp) &&
    rm -f ${SSH_KEY} ${VMDK} &&
    cleanup(){
	echo CLEANING UP &&
	    VBoxManage controlvm ${VM} poweroff soft &&
	    sleep 1m &&
	    VBoxManage unregistervm --delete ${VM} &&
	    sudo lvremove --force /dev/volumes/${VM} &&
	    rm -f ${ISONIX} ${KNOWN_HOSTS1} ${KNOWN_HOSTS2} &&
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
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=${ISONIX} &&
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
    sleep 1m &&
    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS1} &&
    while [ -z "$(cat ${KNOWN_HOSTS1})" ]
    do
	echo waiting for keyscan &&
	    sleep 10s &&
	    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS1} &&
	    sleep 10s
    done &&
    echo waited for keyscan &&
    echo finished waiting for vm &&
    ssh -i ${SSH_KEY} -l root -p ${PORT1} -o UserKnownHostsFile=${KNOWN_HOSTS1} 127.0.0.1 my-install &&
    echo INSTALLED ... NOW POWER OFF &&
    VBoxManage controlvm ${VM} poweroff soft &&
    echo INSTALLED ... NOW POWERED OFF &&
    sleep 1m &&
    echo ABOUT TO REMOVE DISK &&
    VBoxManage storageattach ${VM} --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
    echo REMOVED DISK &&
    VBoxManage startvm --type headless ${VM} &&
    echo ${KNOWN_HOSTS2} &&
    sleep 1m &&
    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS2} &&
    while [ -z "$(cat ${KNOWN_HOSTS2})" ]
    do
	echo waiting for keyscan &&
	    sleep 10s &&
	    ssh-keyscan -p ${PORT1} 127.0.0.1 > ${KNOWN_HOSTS2} &&
	    sleep 10s
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
		--expected)
		    EXPECTED="${2}" &&
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
	    OBSERVED=$(ssh -i ${SSH_KEY} -l user -p ${PORT1} -o UserKnownHostsFile=${KNOWN_HOSTS2} 127.0.0.1 "${COMMAND}") &&
	    echo TITLE=${TITLE} &&
	    echo OBSERVED=${OBSERVED} &&
	    echo EXPECTED=${EXPECTED} &&
	    if [[ 0 != ${1} ]]
	    then
		echo The test command failed with error code ${!} &&
		    exit 66
	    elif [ "${OBSERVED}" != "${EXPECTED}" ]
	    then
		echo Observed did not equal Expected. &&
		    exit 67
	    fi
    } &&
    test_it --title "We have a secrets program." --expected wrong --command secrets &&
    true
