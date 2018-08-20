#!/bin/sh

github \
    --upstream-host github.com \
    --upstream-port 22 \
    --upstream-user git \
    --upstream-organization rebelplutonium \
    --upstream-repository setup \
    --upstream-branch master \
    --upstream-id-rsa upstream.id_rsa \
    --origin-host github.com \
    --origin-port 22 \
    --origin-user git \
    --origin-organization nextmoose \
    --origin-repository setup \
    --origin-id-rsa origin.id_rsa \
    --origin-branch nixos-5 \
    --committer-name "Emory Merryman" \
    --committer-email emory.merryman@gmail.com
