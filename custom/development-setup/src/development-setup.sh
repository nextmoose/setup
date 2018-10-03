#!/bin/sh

mkdir ${HOME}/.ssh &&
    chmod 0700 ${HOME}/.ssh &&
    (cat > ${HOME}/.ssh/config <<EOF
Host Upstream
HostName github.com
User git

EOF
    ) &&
