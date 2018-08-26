#!/bin/sh

github \
    --upstream-host github.com \
    --upstream-port 22 \
    --upstream-user git \
    --upstream-organization NixOS \
    --upstream-repository nixpkgs \
    --upstream-branch master \
    --upstream-id-rsa upstream.id_rsa \
    --upstream-known-hosts upstream.known_hosts \
    --origin-host github.com \
    --origin-port 22 \
    --origin-user git \
    --origin-organization nextmoose \
    --origin-repository nixpkgs \
    --origin-id-rsa origin.id_rsa \
    --origin-known-hosts origin.known_hosts \
    --committer-name "Emory Merryman" \
    --committer-email emory.merryman@gmail.com &
