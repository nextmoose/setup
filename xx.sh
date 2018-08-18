echo p | gdisk /dev/sda | grep "^\s*[0-9]" | sed -e "s#^\s*##" -e "s#\s.*\$##" | while read I
do
	(cat <<EOF
d
${I}
w
y
EOF
	) | gdisk /dev/sda
done
