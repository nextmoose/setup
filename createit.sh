#!/bin/sh

export PORT=27895 &&
    if [ ! -d ../transient ]
    then
	mkdir ../transient
    fi &&
    if [ ! -d ../transient/.ssh ]
    then
	mkdir ../transient/.ssh &&
	    chmod 0700 ../transient/.ssh
    fi &&
    if [ ! -f ../transient/.ssh/config ]
    then
	(cat > ../transient/.ssh/config <<EOF
Host nixos
HostName 127.0.0.1
User user
Port ${PORT}
IdentityFile ~/.ssh/user.id_rsa
UserKnownHostsFile ~/.ssh/known_hosts
EOF
	) &&
	    chmod 0400 ../transient/.ssh/config
    fi &&
    if [ ! -f ../transient/.ssh/host.id_rsa ]
    then
	ssh-keygen -f ../transient/.ssh/host.id_rsa -P "" -C "" &&
	    chmod 0400 ../transient/.ssh/host.id_rsa &&
	    rm -f ../transient/.ssh/host.id_rsa.pub
    fi &&
    if [ ! -f ../transient/.ssh/known_hosts ]
    then
	ssh-keygen -y -f ../transient/.ssh/host.id_rsa > ../transient/.ssh/known_hosts &&
	    chmod 0400 ../transient/.ssh/known_hosts
    fi &&
    if [ ! -f ../transient/.ssh/user.id_rsa ]
    then
	ssh-keygen -f ../transient/.ssh/user.id_rsa -P "" -C "" &&
	    chmod 0400 ../transient/.ssh/user.id_rsa &&
	    rm -f ../transient/.ssh/user.id_rsa
    fi &&
    if [ ! -f ../transient/iso.nix ]
    then
	sed \
	    -e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f ../transient/.ssh/user.id_rsa)#" \
	    -e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
	    -e "w../transient/iso.nix" \
	    iso.nix
    fi &&
    if [ ! -d ../transient/installer ]
    then
	mkdir ../transient/installer
    fi &&
    if [ ! -f ../transient/installer/default.nix ]
    then
	sed \
	    -e "s#AUTHORIZED_KEY_PUBLIC#$(ssh-keygen -y -f id_rsa)#" \
	    -e "s#HASHED_PASSWORD#$(echo password | mkpasswd -m sha-512 --stdin)#" \
	    -e "w../transient/installer/default.nix" \
	    installer.nix
    fi &&
    if [ ! -d ../transient/installer/src ]
    then
	cp -r installer ../transient/installer/src
    fi &&
    if [ -z "$(sudo lvs | grep nixos)" ]
    then
	sudo lvcreate --y --name nixos --size 100GB volumes
    fi &&
    if [ ! -f ../transient/nixos.vmdk ]
    then
	VBoxManage internalcommands createrawvmdk -filename ../transient/nixos.vmdk -rawdisk /dev/volumes/nixos
    fi &&
    if [ ! -d logs ]
    then
	mkdir logs
    fi &&
    (
	LOG_FILE=$(pwd)/logs/nix-build.log.txt &&
	    cd ../transient &&
	    echo AAAA 20 &&
	    time nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix > ${LOG_FILE} &&
	    echo AAAA 21
    ) &&
    if [ -z "$(VBoxManage list vms | grep nixos)" ]
    then
	VBoxManage controlvm nixos poweroff soft &&
	    VBoxManage unregistervm --delete nixos
    fi &&
    VBoxManage createvm --name nixos --groups /nixos --register &&
    VBoxManage storagectl nixos --name "IDE" --add IDE &&
    VBoxManage storageattach nixos --storagectl "IDE" --port 0 --device 0 --type hdd --medium ../transient/nixos.vmdk &&
    VBoxManage storagectl nixos --name "SATA Controller" --add SATA &&
    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium ../transient/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
    VBoxManage modifyvm nixos --natpf1 "guestssh1,tcp,127.0.0.1,${PORT},,22" &&
    VBoxManage modifyvm nixos --nic1 nat &&
    VBoxManage modifyvm nixos --memory 2000 &&
    VBoxManage modifyvm nixos --firmware efi &&
    VBoxManage startvm --type headless nixos &&
    VBoxManage startvm --type nixos &&
    fuckit() {
	time ssh nixos installer > logs/installer.log.txt 2>&1 &&
	    VBoxManage controlvm nixos poweroff soft &&
	    echo INSTALLED ... NOW POWERED OFF &&
	    sleep ${NAP} &&
	    echo ABOUT TO REMOVE DISK &&
	    VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
	    echo REMOVED DISK &&
	    VBoxManage startvm --type headless nixos &&
	    sleep ${NAP} &&
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
		    OBSERVED_OUTPUT="$(ssh nixos \"${COMMAND}\")" &&
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
    }
