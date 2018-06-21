#!/bin/sh

(cat <<EOF
d
1
d
2
d
3
w
Y
EOF
) | gdisk /dev/sda
