#!/bin/sh

(cat <<EOF
n


+200M
EF00
n


+8G
8200
n




w
Y
EOF
) | gdisk /dev/sda
