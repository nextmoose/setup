#!/bin/sh

(cat > ${1}/bin/my-completions <<EOF
#!/bin/sh

EOF
) &&
    ls -1 ${1}/completions | while read FILE
    do
	echo "source ${1}/completions/${FILE} &&" >> ${1}/bin/my-completions
    done &&
    echo true >> ${1}/bin/my-completions &&
    chmod 0555 ${1}/bin/my-completions
