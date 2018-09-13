#!/bin/sh

case ${1} in
    gpg.secret.key)
	sudo cat /secrets/gpg.secret.key
	;;
    gpg.owner.trust)
	sudo cat /secrets/gpg.owner.trust
	;;
    gpg2.secret.key)
	sudo cat /secrets/gpg2.secret.key
	;;
    gpg2.owner.trust)
	sudo cat /secrets/gpg2.owner.trust
	;;
    origin.id_rsa)
	sudo cat /secrets/origin.id_rsa
	;;
    origin.known_hosts)
	sudo cat /secrets/origin.known_hosts
	;;
    upstream.id_rsa)
	sudo cat /secrets/upstream.id_rsa
	;;
    upstream.known_hosts)
	sudo cat /secrets/upstream.known_hosts
	;;
    report.id_rsa)
	sudo cat /secrets/report.id_rsa
	;;
    report.known_hosts)
	sudo cat /secrets/report.known_hosts
	;;
    *)
	Unknown Secret &&
	    echo ${1} &&
	    echo ${0} &&
	    echo ${@} &&
	    exit 64
	;;
esac
