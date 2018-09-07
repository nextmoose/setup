#!/bin/sh

(cat > ${1}/bin/my-completions <<EOF
#!/bin/sh

EOF
) &&
    ls -1 completions ${1}/completions | while read FILE
    do
	echo "source ${1}/completions/${FILE} &&" &&
    done &&
    (cat > ${1}/bin/my-completions <<EOF
true 
EOF
)  
