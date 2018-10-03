#!/bin/sh

export PATH=${PATH}:NETWORKMANAGER &&
    nmcli device wifi connect "Richmond Sq Guest" password "guestwifi"
