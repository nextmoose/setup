#!/bin/sh

# see
# http://www.ee.bgu.ac.il/~microlab/MicroLab/Labs/ScanCodes.htm
PRESS=-- &&
    RELEASE=-- &&
    while read -n1 SYMBOL
    do
	case ${SYMBOL} in
	    "a")
		sh $(dirname ${0})/type-keyboard-key --key "a"
		;;
	    "b")
		sh $(dirname ${0})/type-keyboard-key --key "b"
		;;
	    "c")
		sh $(dirname ${0})/type-keyboard-key --key "c"
		;;
	    "d")
		sh $(dirname ${0})/type-keyboard-key --key "d"
		;;
	    "e")
		sh $(dirname ${0})/type-keyboard-key --key "e"
		;;
	    "f")
		sh $(dirname ${0})/type-keyboard-key --key "f"
		;;
	    "g")
		sh $(dirname ${0})/type-keyboard-key --key "g"
		;;
	    "h")
		sh $(dirname ${0})/type-keyboard-key --key "h"
		;;
	    "i")
		sh $(dirname ${0})/type-keyboard-key --key "i"
		;;
	    "j")
		sh $(dirname ${0})/type-keyboard-key --key "j"
		;;
	    "k")
		sh $(dirname ${0})/type-keyboard-key --key "k"
		;;
	    "l")
		sh $(dirname ${0})/type-keyboard-key --key "l"
		;;
	    "m")
		sh $(dirname ${0})/type-keyboard-key --key "m"
		;;
	    "n")
		sh $(dirname ${0})/type-keyboard-key --key "n"
		;;
	    "o")
		sh $(dirname ${0})/type-keyboard-key --key "o"
		;;
	    "p")
		sh $(dirname ${0})/type-keyboard-key --key "p"
		;;
	    "q")
		sh $(dirname ${0})/type-keyboard-key --key "q"
		;;
	    "r")
		sh $(dirname ${0})/type-keyboard-key --key "r"
		;;
	    "s")
		sh $(dirname ${0})/type-keyboard-key --key "s"
		;;
	    "t")
		sh $(dirname ${0})/type-keyboard-key --key "t"
		;;
	    "u")
		sh $(dirname ${0})/type-keyboard-key --key "u"
		;;
	    "v")
		sh $(dirname ${0})/type-keyboard-key --key "v"
		;;
	    "w")
		sh $(dirname ${0})/type-keyboard-key --key "w"
		;;
	    "x")
		sh $(dirname ${0})/type-keyboard-key --key "x"
		;;
	    "y")
		sh $(dirname ${0})/type-keyboard-key --key "y"
		;;
	    "z")
		sh $(dirname ${0})/type-keyboard-key --key "z"
		;;
	    "A")
		sh $(dirname ${0})/type-keyboard-key --key "a" --case upper
		;;
	    "B")
		sh $(dirname ${0})/type-keyboard-key --key "b" --case upper
		;;
	    "C")
		sh $(dirname ${0})/type-keyboard-key --key "c" --case upper
		;;
	    "D")
		sh $(dirname ${0})/type-keyboard-key --key "d" --case upper
		;;
	    "E")
		sh $(dirname ${0})/type-keyboard-key --key "e" --case upper
		;;
	    "F")
		sh $(dirname ${0})/type-keyboard-key --key "f" --case upper
		;;
	    "G")
		sh $(dirname ${0})/type-keyboard-key --key "g" --case upper
		;;
	    "H")
		sh $(dirname ${0})/type-keyboard-key --key "h" --case upper
		;;
	    "I")
		sh $(dirname ${0})/type-keyboard-key --key "i" --case upper
		;;
	    "J")
		sh $(dirname ${0})/type-keyboard-key --key "j" --case upper
		;;
	    "K")
		sh $(dirname ${0})/type-keyboard-key --key "k" --case upper
		;;
	    "L")
		sh $(dirname ${0})/type-keyboard-key --key "l" --case upper
		;;
	    "M")
		sh $(dirname ${0})/type-keyboard-key --key "m" --case upper
		;;
	    "N")
		sh $(dirname ${0})/type-keyboard-key --key "n" --case upper
		;;
	    "O")
		sh $(dirname ${0})/type-keyboard-key --key "o" --case upper
		;;
	    "P")
		sh $(dirname ${0})/type-keyboard-key --key "p" --case upper
		;;
	    "Q")
		sh $(dirname ${0})/type-keyboard-key --key "q" --case upper
		;;
	    "R")
		sh $(dirname ${0})/type-keyboard-key --key "r" --case upper
		;;
	    "S")
		sh $(dirname ${0})/type-keyboard-key --key "s" --case upper
		;;
	    "T")
		sh $(dirname ${0})/type-keyboard-key --key "t" --case upper
		;;
	    "U")
		sh $(dirname ${0})/type-keyboard-key --key "u" --case upper
		;;
	    "V")
		sh $(dirname ${0})/type-keyboard-key --key "v" --case upper
		;;
	    "W")
		sh $(dirname ${0})/type-keyboard-key --key "w" --case upper
		;;
	    "X")
		sh $(dirname ${0})/type-keyboard-key --key "x" --case upper
		;;
	    "Y")
		sh $(dirname ${0})/type-keyboard-key --key "y" --case upper
		;;
	    "Z")
		sh $(dirname ${0})/type-keyboard-key --key "z" --case upper
		;;
	    "0")
		sh $(dirname ${0})/type-keyboard-key --key "0"
		;;
	    "1")
		sh $(dirname ${0})/type-keyboard-key --key "1"
		;;
	    "2")
		sh $(dirname ${0})/type-keyboard-key --key "2"
		;;
	    "3")
		sh $(dirname ${0})/type-keyboard-key --key "3"
		;;
	    "4")
		sh $(dirname ${0})/type-keyboard-key --key "4"
		;;
	    "5")
		sh $(dirname ${0})/type-keyboard-key --key "5"
		;;
	    "6")
		sh $(dirname ${0})/type-keyboard-key --key "6"
		;;
	    "7")
		sh $(dirname ${0})/type-keyboard-key --key "7"
		;;
	    "8")
		sh $(dirname ${0})/type-keyboard-key --key "8"
		;;
	    "9")
		sh $(dirname ${0})/type-keyboard-key --key "9"
		;;
	    "-")
		sh $(dirname ${0})/type-keyboard-key --key "-"
		;;
 	    "|")
		sh $(dirname ${0})/type-keyboard-key --key "\\"
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
	    if [ "${CASE}" == "upper" ]
	    then
		sudo VBoxManage controlvm nixos keyboardputscancode ${SHIFT_PRESS}
	    fi &&
	    sudo VBoxManage controlvm nixos keyboardputscancode ${PRESS} ${RELEASE} &&
	    if [ "${CASE}" == "upper" ]
	    then
		sudo VBoxManage controlvm nixos keyboardputscancode ${SHIFT_RELEASE}
	    fi		
    done
