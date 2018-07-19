#!/bin/sh

ls -1 /opt/root/scripts/completion | while read COMPLETION
do
	echo sourcing ${COMPLETION} &&
	cat /opt/root/scripts/completion/${COMPLETION} &&
	(source /opt/root/scripts/completion/${COMPLETION} || echo FAILED TO SOURCE ${COMPLETION})
done &&
	export PATH=${PATH}:/opt/root/scripts/bin &&
	bash
