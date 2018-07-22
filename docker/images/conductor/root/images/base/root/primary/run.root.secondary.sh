#!/bin/sh

mkdir /opt/system/tertiary &&
	mkdir /opt/system/tertiary/bin &&
	mkdir /opt/system/tertiary/sbin &&
	mkdir /opt/system/tertiary/sudo &&
	for SCRIPT in $(ls -1 /opt/system/secondary/scripts/bin | grep "[.]sh\$")
	do
		(cat > /opt/system/tertiary/bin <<EOF
#!/bin/sh

sudo /opt/system/tertiary/sbin/${SCRIPT} "\${@}"
EOF
		) &&
			chmod 0555 /opt/system/secondary/scripts/bin/${SCRIPT%.*} &&
			cp /opt/system/secondary/scripts/bin/${SCRIPT} /opt/system/tertiary/sbin/${SCRIPT} &&
			chmod 0500 /opt/system/secondary/scripts/sbin/${SCRIPT} &&
			echo "user ALL=(ALL) NOPASSWD:SETENV /opt/system/tertiary/sbin/${SCRIPT}" > /opt/system/tertiary/sudo/${SCRIPT%.*} &&
			chmod 0444 /opt/system/tertiary/sbin/${SCRIPT%.*} &&
			true
	done
	
