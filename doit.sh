#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    STATUS=FAIL &&
    PORT=20560 &&
    SECRET=b9ad5f5e-9052-408f-949c-5125d77fb2cf &&
    cleanup() {
	echo ${STATUS} &&
	    echo ${WORK_DIR}
    } &&
    trap cleanup EXIT &&
    (
	mkdir ${WORK_DIR}/.ssh &&
	    chmod 0700 ${WORK_DIR}/.ssh &&
	    ssh-keygen -f ${WORK_DIR}/.ssh/id_rsa -P "" -C "" &&
	    (cat > ${WORK_DIR}/.ssh/config <<EOF
Host alpha  
HostName 127.0.0.1
User root
Port ${PORT}
IdentityFile ${WORK_DIR}/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/.ssh/alpha.known_hosts

Host beta
HostName 127.0.0.1
User root
Port ${PORT}
IdentityFile ${WORK_DIR}/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/.ssh/beta.known_hosts

Host gamma
HostName 127.0.0.1
User user
Port ${PORT}
IdentityFile ${WORK_DIR}/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/.ssh/gamma.known_hosts
EOF
	    ) &&
	    chmod 0600 ${WORK_DIR}/.ssh/config &&
	    touch ${WORK_DIR}/.ssh/alpha.known_hosts &&
	    touch ${WORK_DIR}/.ssh/beta.known_hosts &&
	    touch ${WORK_DIR}/.ssh/gamma.known_hosts &&
	    sed \
		-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/.ssh/id_rsa)#" \
		-e "w${WORK_DIR}/iso.nix" \
		iso.nix.template &&
	    mkdir ${WORK_DIR}/installer &&
	    cp installer.nix ${WORK_DIR}/installer/default.nix &&
	    mkdir ${WORK_DIR}/installer/src &&
	    cp installer.sh.template ${WORK_DIR}/installer/src/installer.sh.template &&
	    sed \
		-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/.ssh/id_rsa)#" \
		-e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
		-e "w${WORK_DIR}/installer/src/configuration.nix" \
		configuration.nix.template &&
	    cp -r custom ${WORK_DIR}/installer/src/custom &&
	    mkdir ${WORK_DIR}/installer/src/secrets &&
	    echo ${SECRET} > ${WORK_DIR}/installer/src/secrets/secret
    ) &&
    (
	cd ${WORK_DIR}
	time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    VBoxManage list vms | grep nixos | while read VM
    do
	VBoxManage controlvm nixos poweroff soft &&
	    VBoxManage unregistervm --delete nixos
    done &&
    sudo lvs | grep nixos | while read VOL
    do
	sudo lvremove --force /dev/volumes/nixos
    done &&
    (
	sudo lvcreate -y --name nixos --size 100GB volumes &&
	    VBoxManage internalcommands createrawvmdk -filename ${WORK_DIR}/nixos.vmdk -rawdisk /dev/volumes/nixos &&
	    VBoxManage createvm --name nixos --groups /nixos --register &&
	    VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
	    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium ${WORK_DIR}/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
	    VBoxManage storagectl nixos --name "IDE" --add IDE &&
	    VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium ${WORK_DIR}/nixos.vmdk &&
	    VBoxManage modifyvm nixos --natpf1 "guestssh1,tcp,127.0.0.1,${PORT},,22" &&
	    VBoxManage modifyvm nixos --nic1 nat &&
	    VBoxManage modifyvm nixos --memory 2000 &&
	    VBoxManage modifyvm nixos --firmware efi &&
	    VBoxManage startvm --type headless nixos &&
	    knownhosts() {
		while [ -z "$(cat ${WORK_DIR}/.ssh/${1}.known_hosts)" ]
		do
		    sleep 1s &&
			ssh-keyscan -p ${PORT} 127.0.0.1 > ${WORK_DIR}/.ssh/${1}.known_hosts
		done
	    } &&
	    knownhosts alpha &&
	    time ssh -F ${WORK_DIR}/.ssh/config alpha installer &&
	    VBoxManage controlvm nixos poweroff soft &&
	    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
	    VBoxManage startvm --type headless nixos &&
	    knownhosts gamma &&
	    testit() {
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
	    testit --title "We have a secrets program." --expected-output ${SECRET} --expected-exit-code 0 --command "secrets secret" &&
	    testit --title "We have a secrets program." --expected-output ${SECRET} --expected-exit-code 65 --command "secrets nosecret"
    ) &&
    STATUS=PASS &&
    true
