#!/bin/sh

    lvs --options NAME volumes | tail -n -1 | while read NAME
    do
	    (lvremove --force /dev/volumes/${NAME} || true)
    done &&
	    (vgremove --force /dev/volumes || true) &&
	    (pvremove --force /dev/volumes || true) &&
    (cat <<EOF
d
1
d
2
d
3
d
4
w
Y
EOF
    ) | gdisk /dev/sda
