#!/bin/sh

read -s -p "SYMMETRIC PASSPHRASE? " CONFIRMED_SYMMETRIC_PASSPHRASE &&
    read -s -p "VERIFY SYMMETRIC_PASSPHRASE? " VERIFY_CONFIRMED_SYMMETRIC_PASSPHRASE &&
    if [ "${CONFIRMED_SYMMETRIC_PASSPHRASE}" == "${VERIFY_CONFIRMED_SYMMETRIC_PASSPHRASE}" ]
    then
	echo VERIFIED SYMMETRIC PASSPHRASE
    else
	echo FAILED TO VERIFY SYMMETRIC PASSPHRASE &&
	    exit 65
    fi &&
    read -s -p "LUKS PASSPHRASE? " CONFIRMED_LUKS_PASSPHRASE &&
    read -s -p "VERIFY LUKS_PASSPHRASE? " VERIFY_CONFIRMED_LUKS_PASSPHRASE &&
    if [ "${CONFIRMED_LUKS_PASSPHRASE}" == "${VERIFY_CONFIRMED_LUKS_PASSPHRASE}" ]
    then
	echo VERIFIED LUKS PASSPHRASE
    else
	echo FAILED TO VERIFY LUKS PASSPHRASE &&
	    exit 65
    fi &&
    read -s -p "PASSWORD? " CONFIRMED_PASSWORD &&
    read -s -p "VERIFY PASSWORD? " VERIFY_CONFIRMED_PASSWORD &&
    if [ "${CONFIRMED_PASSWORD}" == "${VERIFY_CONFIRMED_PASSWORD}" ]
    then
	echo VERIFIED PASSWORD
    else
	echo FAILED TO VERIFY PASSWORD &&
	    exit 66
    fi &&
    WORK_DIR=$(mktemp -d) &&
    STATUS=FAIL &&
    ALPHA_PORT=20560 &&
    BETA_PORT=25954 &&
    GAMMA_PORT=29156 &&
    VIRTUAL_SYMMETRIC_PASSPHRASE=$(uuidgen) &&
    VIRTUAL_LUKS_PASSPHRASE=$(uuidgen) &&
    VIRTUAL_PASSWORD=$(uuidgen) &&
    TOKEN=18.03.133245.d16a7abceb7-x86_64-linux &&
    cleanup() {
	echo &&
	    echo &&
	    echo &&
	    echo ${STATUS} &&
	    echo ${WORK_DIR}
    } &&
    trap cleanup EXIT &&
    mkdir ${WORK_DIR}/secrets &&
    mkdir ${WORK_DIR}/secrets/plain &&
    secrets gpg.secret.key > ${WORK_DIR}/secrets/plain/gpg.secret.key &&
    secrets gpg.owner.trust > ${WORK_DIR}/secrets/plain/gpg.owner.trust &&
    secrets gpg2.secret.key > ${WORK_DIR}/secrets/plain/gpg2.secret.key &&
    secrets gpg2.owner.trust > ${WORK_DIR}/secrets/plain/gpg2.owner.trust &&
    secrets upstream.id_rsa > ${WORK_DIR}/secrets/plain/upstream.id_rsa &&
    secrets upstream.known_hosts > ${WORK_DIR}/secrets/plain/upstream.known_hosts &&
    secrets origin.id_rsa > ${WORK_DIR}/secrets/plain/origin.id_rsa &&
    secrets origin.known_hosts > ${WORK_DIR}/secrets/plain/origin.known_hosts &&
    secrets report.id_rsa > ${WORK_DIR}/secrets/plain/report.id_rsa &&
    secrets report.known_hosts > ${WORK_DIR}/secrets/plain/report.known_hosts &&
    echo Richmond Sq Guest > ${WORK_DIR}/secrets/plain/richmondsquare.ssid &&
    echo guestwifi > ${WORK_DIR}/secrets/plain/richmondsquare.password &&
    echo 56LYL > ${WORK_DIR}/secrets/plain/personal.ssid &&
    echo K3Z3ZNNKD9D6B4MC > ${WORK_DIR}/secrets/plain/personal.password &&
    mkdir ${WORK_DIR}/secrets/virtual &&
    mkdir ${WORK_DIR}/secrets/confirmed &&
    ls -1 ${WORK_DIR}/secrets/plain | while read FILE
    do
	echo "${VIRTUAL_SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output ${WORK_DIR}/secrets/virtual/${FILE}.gpg --symmetric ${WORK_DIR}/secrets/plain/${FILE} &&
	    echo "${CONFIRMED_SYMMETRIC_PASSPHRASE}" | gpg --batch --passphrase-fd 0 --output ${WORK_DIR}/secrets/confirmed/${FILE}.gpg --symmetric ${WORK_DIR}/secrets/plain/${FILE} &&
	    rm -f ${WORK_DIR}/secrets/plain/${FILE} &&
	    true
    done &&
    rm -rf ${WORK_DIR}/secrets/plain &&
    (
	mkdir ${WORK_DIR}/virtual &&
	    mkdir ${WORK_DIR}/virtual/.ssh &&
	    chmod 0700 ${WORK_DIR}/virtual/.ssh &&
	    ssh-keygen -f ${WORK_DIR}/virtual/.ssh/id_rsa -P "" -C "" &&
	    (cat > ${WORK_DIR}/virtual/.ssh/config <<EOF
Host alpha  
HostName 127.0.0.1
User root
Port ${ALPHA_PORT}
IdentityFile ${WORK_DIR}/virtual/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/virtual/.ssh/alpha.known_hosts

Host beta
HostName 127.0.0.1
User root
Port ${BETA_PORT}
IdentityFile ${WORK_DIR}/virtual/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/virtual/.ssh/beta.known_hosts

Host gamma
HostName 127.0.0.1
User user
Port ${GAMMA_PORT}
IdentityFile ${WORK_DIR}/virtual/.ssh/id_rsa
UserKnownHostsFile ${WORK_DIR}/virtual/.ssh/gamma.known_hosts
EOF
	    ) &&
	    chmod 0600 ${WORK_DIR}/virtual/.ssh/config &&
	    touch ${WORK_DIR}/virtual/.ssh/alpha.known_hosts &&
	    touch ${WORK_DIR}/virtual/.ssh/beta.known_hosts &&
	    touch ${WORK_DIR}/virtual/.ssh/gamma.known_hosts &&
	    cp iso.nix ${WORK_DIR}/virtual/iso.nix &&
	    sed \
		-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/virtual/.ssh/id_rsa)#" \
		-e "w${WORK_DIR}/virtual/iso.isolated.nix" \
		iso.virtual.nix.template &&
	    mkdir ${WORK_DIR}/virtual/installer &&
	    cp installer.nix ${WORK_DIR}/virtual/installer/default.nix &&
	    mkdir ${WORK_DIR}/virtual/installer/src &&
	    cp installer.sh.template ${WORK_DIR}/virtual/installer/src/installer.sh.template &&
	    cp configuration.nix ${WORK_DIR}/virtual/installer/src/configuration.nix &&
	    sed \
		-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/virtual/.ssh/id_rsa)#" \
		-e "s#HASHED_PASSWORD#$(echo ${VIRTUAL_PASSWORD} | mkpasswd -m sha-512 --stdin)#" \
		-e "w${WORK_DIR}/virtual/installer/src/configuration.isolated.nix" \
		configuration.virtual.nix.template &&
	    cp -r custom ${WORK_DIR}/virtual/installer/src/custom &&
	    cp -r containers ${WORK_DIR}/virtual/installer/src/containers &&
	    cp -r ${WORK_DIR}/secrets/virtual ${WORK_DIR}/virtual/installer/src/secrets &&
	    true
    ) &&
    (
	cd ${WORK_DIR}/virtual &&
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
	# see
	# http://www.ee.bgu.ac.il/~microlab/MicroLab/Labs/ScanCodes.htm
	keyboardputscancode() {
	    PRESS=-- &&
		RELEASE=-- &&
		while read -n1 SYMBOL
		do
		    case ${SYMBOL} in
			"a")
			    PRESS=1E
			    ;;
			"b")
			    PRESS=30
			    ;;
			"c")
			    PRESS=2E
			    ;;
			"d")
			    PRESS=20
			    ;;
			"e")
			    PRESS=12
			    ;;
			"f")
			    PRESS=21
			    ;;
			"g")
			    PRESS=22
			    ;;
			"h")
			    PRESS=23
			    ;;
			"i")
			    PRESS=17
			    ;;
			"j")
			    PRESS=24
			    ;;
			"k")
			    PRESS=25
			    ;;
			"l")
			    PRESS=26
			    ;;
			"m")
			    PRESS=32
			    ;;
			"n")
			    PRESS=31
			    ;;
			"o")
			    PRESS=18
			    ;;
			"p")
			    PRESS=19
			    ;;
			"q")
			    PRESS=10
			    ;;
			"r")
			    PRESS=13
			    ;;
			"s")
			    PRESS=1F
			    ;;
			"t")
			    PRESS=14
			    ;;
			"u")
			    PRESS=16
			    ;;
			"v")
			    PRESS=2F
			    ;;
			"w")
			    PRESS=11
			    ;;
			"x")
			    PRESS=2D
			    ;;
			"y")
			    PRESS=15
			    ;;
			"z")
			    PRESS=2C
			    ;;
			"0")
			    PRESS=0B
			    ;;
			"1")
			    PRESS=02
			    ;;
			"2")
			    PRESS=03
			    ;;
			"3")
			    PRESS=04
			    ;;
			"4")
			    PRESS=05
			    ;;
			"5")
			    PRESS=06
			    ;;
			"6")
			    PRESS=07
			    ;;
			"7")
			    PRESS=08
			    ;;
			"8")
			    PRESS=09
			    ;;
			"9")
			    PRESS=0A
			    ;;
			"-")
			    PRESS=0C
			    ;;
			"_")
			    PRESS=39
			    ;;
			"")
			    PRESS=1C
			    ;;
			*)
			    echo Unknown Symbol &&
				echo ${SYMBOL} &&
				exit 64
			    ;;
		    esac &&
			if [ "${PRESS}" == "--" ]
			then
			    echo Undefined Symbol &&
				echo ${SYMBOL} &&
				exit 65
			fi &&
			RELEASE=$(printf "%X" $((0x${PRESS}+0x80))) &&
			sudo VBoxManage controlvm nixos keyboardputscancode ${PRESS} ${RELEASE}
		done
	} &&
	    sudo lvcreate -y --name nixos --size 100GB volumes &&
	    sudo VBoxManage internalcommands createrawvmdk -filename ${WORK_DIR}/virtual/nixos.vmdk -rawdisk /dev/volumes/nixos &&
	    sudo VBoxManage createvm --name nixos --groups /nixos --register &&
	    sudo VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
	    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium ${WORK_DIR}/virtual/result/iso/nixos-${TOKEN}.iso &&
	    sudo VBoxManage storagectl nixos --name "IDE" --add IDE &&
	    sudo VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium ${WORK_DIR}/virtual/nixos.vmdk &&
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
		while [ -z "$(cat ${WORK_DIR}/virtual/.ssh/${1}.known_hosts)" ]
		do
		    sleep 1s &&
			ssh-keyscan -p ${2} 127.0.0.1 > ${WORK_DIR}/virtual/.ssh/${1}.known_hosts
		done
	    } &&
	    knownhosts alpha ${ALPHA_PORT} &&
	    (cat <<EOF
${VIRTUAL_SYMMETRIC_PASSPHRASE}
${VIRTUAL_SYMMETRIC_PASSPHRASE}
${VIRTUAL_LUKS_PASSPHRASE}
${VIRTUAL_LUKS_PASSPHRASE}
EOF
	    ) | time ssh -F ${WORK_DIR}/virtual/.ssh/config alpha installer --no-shutdown --no-volumes &&
	    sudo VBoxManage controlvm nixos poweroff soft &&
	    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
	    sudo VBoxManage startvm --type headless nixos &&
	    sleep 1m &&
	    echo KEYING IN LUKS PASSWORD &&
	    echo "${VIRTUAL_LUKS_PASSPHRASE}" | keyboardputscancode &&
	    echo KEYED IN LUKS PASSWORD &&
	    knownhosts gamma ${GAMMA_PORT} &&
	    testit() {
		TITLE= &&
		    EXPECTED_EXIT_CODE="" &&
		    EXPECTED_OUTPUT="" &&
		    COMMAND="" &&
		    SENSITIVE="false" &&
		    VOLATILE="false" &&
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
			    --sensitive)
				SENSITIVE="true" &&
				    shift
				;;
			    --volatile)
				VOLATILE="true" &&
				    shift
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
		    if [ "${SENSITIVE}" == "true" ]
		    then
			echo MD5SUM EXPECTED_OUTPUT=$(echo ${EXPECTED_OUTPUT} | md5sum -)
		    else
			echo EXPECTED_OUTPUT=${EXPECTED_OUTPUT}
		    fi &&
		    echo EXPECTED_EXIT_CODE=${EXPECTED_EXIT_CODE} &&
		    BEFORE=$(date +%s) &&
		    OBSERVED_OUTPUT="$(ssh -F ${WORK_DIR}/virtual/.ssh/config gamma ${COMMAND})"
		OBSERVED_EXIT_CODE=${?} &&
		    AFTER=$(date +%s) &&
		    echo DURATION=$((${AFTER}-${BEFORE})) &&
		    if [ "${SENSITIVE}" == "true" ]
		    then
			echo MD5SUM OBSERVED_OUTPUT=$(echo ${OBSERVED_OUTPUT} | md5sum -)
		    else
			echo OBSERVED_OUTPUT=${OBSERVED_OUTPUT}
		    fi &&
		    echo OBSERVED_EXIT_CODE=${OBSERVED_EXIT_CODE} &&
		    if [ "${OBSERVED_EXIT_CODE}" != "${EXPECTED_EXIT_CODE}" ]
		    then
			echo Unexpected exit code &&
			    exit 66
		    elif [ "$VOLATILE}" == "false" ] && [ "${OBSERVED_OUTPUT}" != "${EXPECTED_OUTPUT}" ]
		    then
			echo Unexpected output &&
			    exit 67
		    else
			echo SUCCESS
		    fi &&
		    date
	    } &&
	    testit --title "HAS SECRETS PROGRAM" --expected-exit-code 0 --command "which secrets" --volatile &&
	    testit --title "GPG SECRET KEY" --expected-output "$(secrets gpg.secret.key)" --expected-exit-code 0 --command "secrets gpg.secret.key" --sensitive &&
	    testit --title "GPG OWNER TRUST" --expected-output "$(secrets gpg.owner.trust)" --expected-exit-code 0 --command "secrets gpg.owner.trust" --sensitive &&
	    testit --title "GPG2 SECRET KEY" --expected-output "$(secrets gpg2.secret.key)" --expected-exit-code 0 --command "secrets gpg2.secret.key" --sensitive &&
	    testit --title "GPG2 OWNER TRUST" --expected-output "$(secrets gpg2.owner.trust)" --expected-exit-code 0 --command "secrets gpg2.owner.trust" --sensitive &&
	    testit --title "UPSTREAM ID RSA" --expected-output "$(secrets upstream.id_rsa)" --expected-exit-code 0 --command "secrets upstream.id_rsa" --sensitive &&
	    testit --title "UPSTREAM KNOWN HOSTS" --expected-output "$(secrets upstream.known_hosts)" --expected-exit-code 0 --command "secrets upstream.known_hosts" --sensitive &&
	    testit --title "ORIGIN ID RSA" --expected-output "$(secrets origin.id_rsa)" --expected-exit-code 0 --command "secrets origin.id_rsa" --sensitive &&
	    testit --title "ORIGIN KNOWN HOSTS" --expected-output "$(secrets origin.known_hosts)" --expected-exit-code 0 --command "secrets origin.known_hosts" --sensitive &&
	    testit --title "REPORT ID RSA" --expected-output "$(secrets report.id_rsa)" --expected-exit-code 0 --command "secrets report.id_rsa" --sensitive &&
	    testit --title "REPORT KNOWN HOSTS" --expected-output "$(secrets report.known_hosts)" --expected-exit-code 0 --command "secrets report.known_hosts" --sensitive &&
	    testit --title "RICHMOND SQUARE WIFI SSID" --expected-output "Richmond Sq Guest" --expected-exit-code 0 --command "secrets richmondsquare.ssid" &&
	    testit --title "RICHMOND SQUARE WIFI SSID" --expected-output "guestwifi" --expected-exit-code 0 --command "secrets richmondsquare.password" &&
	    testit --title "PERSONAL WIFI SSID" --expected-output "56LYL" --expected-exit-code 0 --command "secrets personal.ssid" &&
	    testit --title "PERSONAL WIFI SSID" --expected-output "K3Z3ZNNKD9D6B4MC" --expected-exit-code 0 --command "secrets personal.password" &&
	    testit --title "HAS WIFI PROGRAM" --expected-exit-code 0 --command "which wifi" --volatile &&
	    testit --title "HAS LOCAL DEVELOPMENT PROGRAM" --expected-exit-code 0 --command "which development-setup" --volatile &&
	    testit --title "HAS LOCAL DEVELOPMENT PROGRAM" --expected-exit-code 0 --command "which old-pass" --volatile &&
	    true
    ) &&
    (
	mkdir ${WORK_DIR}/confirmed &&
	    cp iso.nix ${WORK_DIR}/confirmed/iso.nix &&
	    sed \
		-e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ${WORK_DIR}/confirmed/.ssh/id_rsa)#" \
		-e "w${WORK_DIR}/confirmed/iso.isolated.nix" \
		iso.confirmed.nix.template &&
	    mkdir ${WORK_DIR}/confirmed/installer &&
	    cp installer.nix ${WORK_DIR}/confirmed/installer/default.nix &&
	    mkdir ${WORK_DIR}/confirmed/installer/src &&
	    cp installer.sh.template ${WORK_DIR}/confirmed/installer/src/installer.sh.template &&
	    cp configuration.nix ${WORK_DIR}/confirmed/installer/src/configuration.nix &&
	    sed \
		-e "s#HASHED_PASSWORD#$(echo ${CONFIRMED_PASSWORD} | mkpasswd -m sha-512 --stdin)#" \
		-e "w${WORK_DIR}/confirmed/installer/src/configuration.isolated.nix" \
		configuration.confirmed.nix.template &&
	    cp -r custom ${WORK_DIR}/confirmed/installer/src/custom &&
	    cp -r containers ${WORK_DIR}/confirmed/installer/src/containers &&
	    cp -r ${WORK_DIR}/secrets/confirmed ${WORK_DIR}/confirmed/installer/src/secrets
    ) &&
    (
	cd ${WORK_DIR}/confirmed &&
	    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
    ) &&
    STATUS=PASS &&    
    true
