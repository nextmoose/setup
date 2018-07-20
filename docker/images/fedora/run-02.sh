#!/bin/sh

mkdir /opt/system/{bin,sbin,sudo,completion} &&
	for SCRIPT in $(ls -1 /opt/system/germ/scripts/sbin)
	do
		(cat > /opt/system/bin/${SCRIPT%.*} <<EOF
#!/bin/sh

sudo --preserve-env /opt/system/sbin/${SCRIPT} "\${@}"
EOF
		) &&
			chmod 0555 /opt/system/bin/${SCRIPT%.*} &&
			(cat > /opt/system/sbin/${SCRIPT} <<EOF
#!/bin/sh

while [ \${#} -gt 0 ]
do
	case \${1} in
EOF
			) &&
			cat /opt/system/germ/scripts/config/${SCRIPT%.*}.csv | while read LINE
			do
				ALPHA=$(echo ${LINE} | cut -f 1 -d " ") &&
				BETA=$(echo ${LINE} | cut -f2 -d " ") &&
				echo -e "\t\t${ALPHA}) export ${BETA} && shift 2 ;;"
			done | tee --append /opt/system/sbin/${SCRIPT} &&
			(cat >> /opt/system/sbin/${SCRIPT} <<EOF
		*) echo Unknown Option && echo \${1} && echo \${0} && echo \${@} && exit 64 ;;
	esac
done &&	
EOF
			) &&
			echo -en "\t" >> /opt/system/sbin/${SCRIPT} &&
			tail -n +3 /opt/system/germ/scripts/sbin/${SCRIPT} >> /opt/system/sbin/${SCRIPT} &&
			chmod 0500 /opt/system/sbin/${SCRIPT}
			true
	done
