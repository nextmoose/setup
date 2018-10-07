#!/bin/sh

sh $(dirname ${0})/destroy-box.sh &&
    sh $(dirname ${0})/destroy-dot-ssh.sh &&
    SYMMETRIC_PASSPHRASE=$(uuidgen) &&
    USER_PASSWORD=$(uuidgen) &&
    (cat <<EOF sh $(dirname ${0})/create-dot-ssh.sh &&
${SYMMETRIC_PASSPHRASE}
${SYMMETRIC_PASSPHRASE}
${USER_PASSWORD}
${USER_PASSWORD}
EOF
    ) | sh $(dirname ${0})/create-virtual-iso.sh &&
    rm --force ~/.ssh/virtual-install.known_hosts &&
    while [ -z "$(cat build/dot-ssh/install.known_hosts)" ]
    do
	sleep 1s &&
	    ssh-keyscan -p 20560 127.0.0.1 > ~/.ssh/virtual-install.known_hosts
    done &&
    LUKS_PASSPHRASE=$(uuidgen) &&
    (cat <<EOF
${SYMMETRIC_PASSPHRASE}
${SYMMETRIC_PASSPHRASE}
${LUKS_PASSPHRASE}
${LUKS_PASSPHRASE}
EOF
    ) | time ssh -F build/dot-ssh/config install installer --no-shutdown --no-volumes &&
    sudo VBoxManage controlvm nixos poweroff soft &&
    sudo VBoxManage storageattach nixos --storagectl "SATA Controller" --port 0 --device 0 --medium none &&
    sudo VBoxManage startvm --type headless nixos &&
    sleep 1m &&
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
    echo "${LUKS_PASSPHRASE}" | keyboardputscancode &&
    true
