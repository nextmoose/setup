#!/bin/sh

WORK_DIR=$(mktemp -d) &&
    STATUS=FAIL &&
    ALPHA_PORT=20560 &&
    BETA_PORT=25954 &&
    GAMMA_PORT=29156 &&
    SYMMETRIC_PASSPHRASE=9c17b0a7-5288-41ca-8f69-899db249a0f1 &&
    LUKS_PASSPHRASE=password &&
    LUKS_CODE="19 1E 1F 1F 11 18 13 20 1C" &&
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
    if [ "$(sudo VBoxManage showvminfo nixos)" ]
    then
	if [ "0" != "$(sudo VBoxManage showvminfo nixos | grep -c running)" ]
	then
	    sudo VBoxManage controlvm nixos poweroff soft &&
		sleep 10s
	fi &&
	    if [ "0" != "$(sudo VBoxManage list vms | grep -c nixos)" ]
	    then
		sudo VBoxManage unregistervm --delete nixos &&
		    sleep 10s
	    fi
    fi &&
    if [ "0" != "$(sudo lvs | grep -c nixos)" ]
    then
	sudo lvremove --force /dev/volumes/nixos
    fi &&
    (
	keyboardputscancode() {
	    PRESS= &&
		RELEASE= &&
		for SYMBOL in ${@}
		do
		    case ${SYMBOL} in
			"alfa")
			    PRESS=1E
			    ;;
			"bravo")
			    ;;
			"charlie")
			    PRESS=2E
			    ;;
			"delta")
			    ;;
			"echo")
			    PRESS=12
			    ;;
			"foxtrot")
			    ;;
			"golf")
			    ;;
			"hotel")
			    PRESS=23
			    ;;
			"india")
			    PRESS=17
			    ;;
			"juiliett")
			    ;;
			"kilo")
			    ;;
			"lima")
			    PRESS=26
			    ;;
			"mike")
			    PRESS=32
			    ;;
			"november")
			    PRESS=31
			    ;;
			"oscar")
			    ;;
			"papa")
			    PRESS=19
			    ;;
			"quebec")
			    ;;
			"romeo")
			    PRESS=13
			    ;;
			"sierra")
			    PRESS=1F
			    ;;
			"tango")
			    PRESS=14
			    ;;
			"uniform")
			    PRESS=16
			    ;;
			"victor")
			    ;;
			"whiskey")
			    ;;
			"xray")
			    ;;
			"yankee")
			    PRESS=15
			    ;;
			"zulu")
			    ;;
			"zero")
			    ;;
			"one")
			    ;;
			"two")
			    ;;
			"three")
			    ;;
			"four")
			    ;;
			"five")
			    ;;
			"six")
			    ;;
			"seven")
			    ;;
			"eight")
			    ;;
			"nine")
			    ;;
			"space")
			    PRESS=39
			    ;;
			"hypen")
			    PRESS=0C
			    ;;
			"enter")
			    PRESS=1C
			    ;;
			*)
			    echo Unknown Symbol &&
				echo ${SYMBOL} &&
				exit 64
		    esac &&
			if [ -z "${PRESS}" ]
			then
			    echo Undefined Symbol &&
				echo ${SYMBOL} &&
				exit 65
			fi &&
			RELEASE=$(printf "%X" $((0x${PRESS}+0x80))) &&
			echo sudo VBoxManage controlvm nixos keyboardputscancode ${SYMBOL} ${PRESS} ${RELEASE} &&
			sudo VBoxManage controlvm nixos keyboardputscancode ${PRESS} ${RELEASE} &&
			sleep 10s
		done
	} &&
	    sudo lvcreate -y --name nixos --size 100GB volumes &&
	    sudo VBoxManage internalcommands createrawvmdk -filename ${WORK_DIR}/nixos.vmdk -rawdisk /dev/volumes/nixos &&
	    sudo VBoxManage createvm --name nixos --groups /nixos --register &&
	    sudo VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
	    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium ${WORK_DIR}/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
	    sudo VBoxManage storagectl nixos --name "IDE" --add IDE &&
	    sudo VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium ${WORK_DIR}/nixos.vmdk &&
	    sudo VBoxManage modifyvm nixos --natpf1 "alpha,tcp,127.0.0.1,${ALPHA_PORT},,22" &&
	    sudo VBoxManage modifyvm nixos --natpf1 "beta,tcp,127.0.0.1,${BETA_PORT},,22" &&
	    sudo VBoxManage modifyvm nixos --natpf1 "gamma,tcp,127.0.0.1,${GAMMA_PORT},,22" &&
	    sudo VBoxManage modifyvm nixos --nic1 nat &&
	    sudo VBoxManage modifyvm nixos --nic2 bridged &&
	    sudo VBoxManage modifyvm nixos --bridgeadapter2 wlo1 &&
	    sudo VBoxManage modifyvm nixos --memory 2000 &&
	    sudo VBoxManage modifyvm nixos --firmware efi &&
	    sudo VBoxManage startvm --type headless nixos &&
	    knownhosts() {
		while [ -z "$(cat ${WORK_DIR}/.ssh/${1}.known_hosts)" ]
		do
		    sleep 1s &&
			ssh-keyscan -p ${2} 127.0.0.1 > ${WORK_DIR}/.ssh/${1}.known_hosts
		done
	    } &&
	    knownhosts alpha ${ALPHA_PORT} &&
	    keyboardputscancode india sierra tango alfa lima lima echo romeo space hyphen hyphen lima uniform kilo sierra hypen papa alfa sierra sierra papa hotel romeo alfa sierra echo space papa alfa sierra sierra papa hotel romeo alfa sierra echo space hyphen hyphen sierra yankee mike mike echo tango romeo india charlie hypen papa alfa sierra sierra papa hotel romeo alfa sierra echo space papa alfa sierra sierra papa hotel romeo alfa sierra echo enter &&
#	    ssh -F ${WORK_DIR}/.ssh/config alpha installer --symmetric-passphrase "${SYMMETRIC_PASSPHRASE}" --luks-passphrase "${LUKS_PASSPHRASE}" &&
	    while [ "0" != "$(sudo VBoxManage showvminfo nixos | grep -c running)" ]
	    do
		echo waiting for install to complete &&
		    sleep 10s
	    done &&
	    sudo VBoxManage controlvm nixos poweroff soft &&
	    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
	    sudo VBoxManage startvm --type headless nixos &&
	    sleep 1m &&
	    echo KEYING IN LUKS PASSWORD &&
	    keyboardputscancode papa alfa sierra sierra papa hotel romeo alfa sierra echo enter &&
#	    sudo VBoxManage controlvm nixos keyboardputscancode 19 99 1E 9E 1F 9F 1F 9F 11 91 18 98 13 93 20 A0 1C 9C &&
	    echo KEYED IN LUKS PASSWORD &&
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
