#!/bin/sh

wpa_supplicant -B -i wlo1 -c <(wpa_passphrase 'Richmond Sq Guest' 'guestwifi')
