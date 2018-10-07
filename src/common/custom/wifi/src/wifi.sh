#!/bin/sh

export PATH=${PATH}:NETWORKMANAGER &&
    if [ ! -f ${HOME}/.wifi ]
    then
	nmcli device wifi connect "Richmond Sq Guest" password "guestwifi" &&
	    touch ${HOME}/.wifi
    fi
