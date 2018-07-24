#!/bin/sh

mkdir /opt/system/tertiary &&
	mkdir /opt/system/tertiary/bin &&
	mkdir /opt/system/tertiary/sbin &&
	mkdir /opt/system/tertiary/sudo &&
	if [ -d /opt/system/secondary/scripts/bin ]
	then
		for SCRIPT in $(ls -1 /opt/system/secondary/scripts/bin | grep "[.]sh\$")
		do
			cp /opt/system/secondary/scripts/bin/${SCRIPT} /opt/system/tertiary/bin/${SCRIPT%.*} &&
				chmod 0555 /opt/system/tertiary/bin/${SCRIPT%.*} &&
				true
		done
	fi &&
	if [ -d /opt/system/secondary/scripts/sbin ]
	then
		for SCRIPT in $(ls -1 /opt/system/secondary/scripts/sbin | grep "[.]sh\$")
		do
			(cat > /opt/system/tertiary/bin/${SCRIPT%.*} <<EOF
#!/bin/sh

sudo --preserve-env /opt/system/tertiary/sbin/${SCRIPT} "\${@}"
EOF
		) &&
				chmod 0555 /opt/system/tertiary/bin/${SCRIPT%.*} &&
				cp /opt/system/secondary/scripts/sbin/${SCRIPT} /opt/system/tertiary/sbin/${SCRIPT} &&
				chmod 0500 /opt/system/tertiary/sbin/${SCRIPT} &&
				echo "user ALL=(ALL) NOPASSWD:SETENV: /opt/system/tertiary/sbin/${SCRIPT}" > /opt/system/tertiary/sudo/${SCRIPT%.*} &&
				chmod 0444 /opt/system/tertiary/sudo/${SCRIPT%.*} &&
				true
		done
	fi &&
	true
