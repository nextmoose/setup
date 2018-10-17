#!/bin/sh

SHIFT_PRESS=2A &&
    SHIFT_RELEASE=$(printf "%X" $((0x${SHIFT_PRESS}+0x80))) &&
    CASE="lower" &&
    while [ ${#} -gt 0 ]
    do
	case "${1}" in
	    --key)
		KEY="${2}" &&
		    shift 2
		;;
	    --case)
		CASE="${2}" &&
		    shift 2
		;;
	    *)
		echo Unknown Option &&
		    echo ${1} &&
		    echo ${@} &&
		    echo ${0} &&
		    exit 64
		;;
	esac
    done &&
    if [ -z "${KEY}" ]
    then
	echo Undefined KEY &&
	    exit 65
    fi &&
    case "${KEY}" in
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
	"A")
	    PRESS=1E
	    ;;
	"B")
	    PRESS=30
	    ;;
	"C")
	    PRESS=2E
	    ;;
	"D")
	    PRESS=20
	    ;;
	"E")
	    PRESS=12
	    ;;
	"F")
	    PRESS=21
	    ;;
	"G")
	    PRESS=22
	    ;;
	"H")
	    PRESS=23
	    ;;
	"I")
	    PRESS=17
	    ;;
	"J")
	    PRESS=24
	    ;;
	"K")
	    PRESS=25
	    ;;
	"L")
	    PRESS=26
	    ;;
	"M")
	    PRESS=32
	    ;;
	"N")
	    PRESS=31
	    ;;
	"O")
	    PRESS=18
	    ;;
	"P")
	    PRESS=19
	    ;;
	"Q")
	    PRESS=10
	    ;;
	"R")
	    PRESS=13
	    ;;
	"S")
	    PRESS=1F
	    ;;
	"T")
	    PRESS=14
	    ;;
	"U")
	    PRESS=16
	    ;;
	"V")
	    PRESS=2F
	    ;;
	"W")
	    PRESS=11
	    ;;
	"X")
	    PRESS=2D
	    ;;
	"Y")
	    PRESS=15
	    ;;
	"Z")
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
 	"|")
	    PRESS=2B
	    ;;
	"SPACE")
	    PRESS=39
	    ;;
	"RETURN")
	    PRESS=1C
	    ;;
	*)
	    echo "Unknown Key \"${KEY}\"" &&
		exit 64
	    ;;
    esac &&
    if [ "${PRESS}" == "--" ]
    then
	echo Undefined Key &&
	    echo ${KEY} &&
	    exit 65
    fi &&
    RELEASE=$(printf "%X" $((0x${PRESS}+0x80))) &&
    if [ "${CASE}" == "upper" ]
    then
	sudo VBoxManage controlvm nixos keyboardputscancode ${SHIFT_PRESS}
    fi &&
    sudo VBoxManage controlvm nixos keyboardputscancode ${PRESS} ${RELEASE} &&
    if [ "${CASE}" == "upper" ]
    then
	sudo VBoxManage controlvm nixos keyboardputscancode ${SHIFT_RELEASE}
    fi &&
    true
