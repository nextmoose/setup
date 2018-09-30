#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    STATUS=FAIL &&
    ALPHA_PORT=20560 &&
    BETA_PORT=25954 &&
    GAMMA_PORT=29156 &&
    SYMMETRIC_PASSPHRASE=9c17b0a7-5288-41ca-8f69-899db249a0f1 &&
    LUKS_PASSPHRASE=password &&
    LUKS_CODE=191E1F1F111813201C &&
    cleanup() {
	echo ${STATUS} &&
	    echo ${WORK_DIR}
    } &&
    trap cleanup EXIT &&
    (
	mkdir ${WORK_DIR}/.ssh &&
	    chmod 0700 ${WORK_DIR}/.ssh &&
	    ssh-keygen -f ${WORK_DIR}/.ssh/id_rsa -P "" -C "" &&
	    dropbearkey -t rsa -f ${WORK_DIR}/.ssh/beta.id_rsa &&
	    dropbearkey -t dss -f ${WORK_DIR}/.ssh/beta.id_dss &&
	    dropbearkey -t ecdsa -f ${WORK_DIR}/.ssh/beta.id_ecdsa &&
	    (cat > ${WORK_DIR}/.ssh/config <<EOF
Host alpha  
HostName 127.0.0.1
User root
Port ${ALPHA_PORT}
IdentityFile ${WORK_DIR}/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/.ssh/alpha.known_hosts

Host beta
HostName 127.0.0.1
User root
Port ${BETA_PORT}
IdentityFile ${WORK_DIR}/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/.ssh/beta.known_hosts

Host gamma
HostName 127.0.0.1
User user
Port ${GAMMA_PORT}
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
	    cp ${WORK_DIR}/.ssh/beta.id_rsa ${WORK_DIR}/installer/src/beta.id_rsa &&
	    cp ${WORK_DIR}/.ssh/beta.id_dss ${WORK_DIR}/installer/src/beta.id_dss &&
	    cp ${WORK_DIR}/.ssh/beta.id_ecdsa ${WORK_DIR}/installer/src/beta.id_ecdsa &&
	    sed \
		-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/.ssh/id_rsa)#" \
		-e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
		-e "w${WORK_DIR}/installer/src/configuration.nix" \
		configuration.nix.template &&
	    cp -r custom ${WORK_DIR}/installer/src/custom &&
	    mkdir ${WORK_DIR}/installer/src/secrets &&
	    echo ${SYMMETRIC_PASSPHRASE} | gpg --batch --passphrase-fd 0 --output ${WORK_DIR}/installer/src/secrets/secret.txt.gpg --symmetric secret.txt
    ) &&
    (
	cd ${WORK_DIR}
	time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    if VBoxManage showvminfo nixos
    then
	if [ "0" != "$(VBoxManage showvminfo nixos | grep -c running)" ]
	then
	    VBoxManage controlvm nixos poweroff soft &&
		sleep 10s
	fi &&
	if [ "0" != "$(VBoxManage list vms | grep -c nixos)" ]
	then
	    VBoxManage unregistervm --delete nixos &&
		sleep 10s
	fi
    fi &&
    if [ "0" != "$(sudo lvs | grep -c nixos)" ]
    then
	sudo lvremove --force /dev/volumes/nixos
    fi &&
    (
	sudo lvcreate -y --name nixos --size 100GB volumes &&
	    VBoxManage internalcommands createrawvmdk -filename ${WORK_DIR}/nixos.vmdk -rawdisk /dev/volumes/nixos &&
	    VBoxManage createvm --name nixos --groups /nixos --register &&
	    VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
	    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium ${WORK_DIR}/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
	    VBoxManage storagectl nixos --name "IDE" --add IDE &&
	    VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium ${WORK_DIR}/nixos.vmdk &&
	    VBoxManage modifyvm nixos --natpf1 "alpha,tcp,127.0.0.1,${ALPHA_PORT},,22" &&
	    VBoxManage modifyvm nixos --natpf1 "beta,tcp,127.0.0.1,${BETA_PORT},,22" &&
	    VBoxManage modifyvm nixos --natpf1 "gamma,tcp,127.0.0.1,${GAMMA_PORT},,22" &&
	    VBoxManage modifyvm nixos --nic1 nat &&
	    VBoxManage modifyvm nixos --nic2 bridged &&
	    VBoxManage modifyvm nixos --bridgeadapter2 wlo1 &&
	    VBoxManage modifyvm nixos --memory 2000 &&
	    VBoxManage modifyvm nixos --firmware efi &&
	    VBoxManage startvm --type headless nixos &&
	    knownhosts() {
		while [ -z "$(cat ${WORK_DIR}/.ssh/${1}.known_hosts)" ]
		do
		    sleep 1s &&
			ssh-keyscan -p ${2} 127.0.0.1 > ${WORK_DIR}/.ssh/${1}.known_hosts
		done
	    } &&
	    knownhosts alpha ${ALPHA_PORT} &&
	    time ssh -F ${WORK_DIR}/.ssh/config alpha installer --symmetric-passphrase "${SYMMETRIC_PASSPHRASE}" --luks-passphrase "${LUKS_PASSPHRASE}" &&
	    echo time ssh -F ${WORK_DIR}/.ssh/config alpha installer --symmetric-passphrase "${SYMMETRIC_PASSPHRASE}" --luks-passphrase "${LUKS_PASSPHRASE}" &&
	    ssh -F ${WORK_DIR}/.ssh/config alpha ifconfig &&
	    VBoxManage controlvm nixos poweroff soft &&
	    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
	    VBoxManage startvm --type headless nixos &&
	    sleep 1m &&
	    VBoxManage controlvm nixos keyboardputscancode ${LUKS_CODE} &&
#	    knownhosts beta ${BETA_PORT} &&
#	    ssh -F ${WORK_DIR}/.ssh/config beta &&
	    knownhosts gamma ${GAMMA_PORT} &&
	    testit() {
		TITLE= &&
		    EXPECTED_EXIT_CODE= &&
		    EXPECTED_OUTPUT= &&
		    COMMAND= &&
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
		    echo &&
		    date &&
		    echo TITLE=${TITLE} &&
		    echo COMMAND=${COMMAND} &&
		    echo EXPECTED_OUTPUT=${EXPECTED_OUTPUT} &&
		    echo EXPECTED_EXIT_CODE=${EXPECTED_EXIT_CODE} &&
		    BEFORE=$(date +%s) &&
		    OBSERVED_OUTPUT="$(ssh -F ${WORK_DIR}/.ssh/config gamma ${COMMAND})"
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
		    fi &&
		    date
	    } &&
	    testit --title "We have a secrets program." --expected-output $(cat secret.txt) --expected-exit-code 0 --command "secrets secret.txt" &&
	    testit --title "We have a secrets program.  It fails on undefined secrets." --expected-exit-code 65 --command "secrets nosecret"
    ) &&
    STATUS=PASS &&
    true
