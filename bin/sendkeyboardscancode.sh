#!/bin/sh

# see
# http://www.ee.bgu.ac.il/~microlab/MicroLab/Labs/ScanCodes.htm
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
	    "|")
		PRESS=2B
		;;
	    " ")
		PRESS=39
		;;
	    "")
		PRESS=1C
		;;
	    *)
		echo "Unknown Symbol \"${SYMBOL}\"" &&
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
