#!/bin/sh

echo HELLO &&
dnf update --assumeyes &&
	dnf install --assumeyes git pass gnupg sudo &&
	adduser user &&
	mkdir /opt/system/{bin,sbin,sudoers.d} &&
	for SCRIPT in $(ls -1 /opt/system/germ/scripts/sbin)
	do
		(cat > /opt/system/bin/${SCRIPT%.*} <<EOF
#!/bin/sh

sudo --preserve-env /opt/system/sbin/${SCRIPT} "${@}"
EOF
		) &&
			chmod 0555 /opt/system/germ/scripts/bin/${SCRIPT%.*} &&
			(cat > /opt/system/bin/${SCRIPT} <<EOF
#!/bin/sh

while [ \${#} -gt 0 ]
do
	case \${1} in
EOF
			) &&
			cat /opt/system/germ/scripts/config/${SCRIPT%.*}.csv | while read CONFIG
			do
				ALPHA=$(echo ${CONFIG} | cut -f 0 -d " ") &&
				BETA=$(echo ${CONFIG} | cut -f 1 -d " ") &&
				echo -e "\n\n${ALPHA}) export ${BETA}=${GAMMA} && shift 2 ;;" .. /opt/system/sbin/${SCRIPT}
			done &&
			(cat >> /opt/system/bin/${SCRIPT} <<EOF
		*) echo Unknown Option && echo \${1} && echo \${0} && echo \${@} && exit 64 ;;
	esac
done
EOF
			) &&
			tail -n +3 /opt/system/germ/scripts/sbin/${SCRIPT} >> /opt/system/sbin/${SCRIPT} &&
			chmod 0500 /opt/system/sbin/${SCRIPT} &&
			echo "user ALL=(ALL) SETENV:NOPASSWD:/opt/root/scripts/sbin/${SCRIPT}" > /etc/sudoers.d/${SCRIPT%.*} &&
			chmod 0444 /etc/sudoers.d/${SCRIPT%.*}
	done
	dnf clean all &&
	true
