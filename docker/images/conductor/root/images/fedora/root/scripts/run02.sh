#!/bin/sh

mkdir /opt/system/{bin,sbin,sudoers,completion} &&
	for SCRIPT in $(ls -1 /opt/system/germ/scripts/sbin)
	do
		(cat > /opt/system/bin/${SCRIPT%.*} <<EOF
#!/bin/sh

sudo --preserve-env /opt/system/bin/${SCRIPT} "\${@}"
EOF
		) &&
		chmod 0555 /opt/system/bin/${SCRIPT%.*} &&
		true
	done &&
	true
