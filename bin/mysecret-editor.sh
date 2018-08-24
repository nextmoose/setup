#!/bin/sh

secret-editor \
    --gpg-secret-key gpg.secret.key \
    --gpg-owner-trust gpg.owner.trust \
    --gpg2-secret-key gpg.secret.key \
    --gpg2-owner-trust gpg.owner.trust \
    --origin-organization desertedscorpion \
    --origin-repository passwordstore \
    --origin-id-rsa origin.id_rsa \
    --origin-known-hosts origin.known_hosts \
    --committer-name "Emory Merryman" \
    --committer-email "emory.merryman@gmail.com"
