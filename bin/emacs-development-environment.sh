#!/bin/sh

github \
    --upstream-host github.com \
    --upstream-port 22 \
    --upstream-user git \
    --upstream-organization rebelplutonium \
    --upstream-repository development-environment \
    --upstream-id-rsa upstream.id_rsa \
    --upstream-known-hosts upstream.known_hosts \
    --origin-host github.com \
    --origin-port 22 \
    --origin-user git \
    --origin-organization nextmoose \
    --origin-repository development-environment \
    --origin-id-rsa origin.id_rsa \
    --origin-known-hosts origin.known_hosts \
    --report-host github.com \
    --report-port 22 \
    --report-user git \
    --report-organization nextmoose \
    --report-repository development-environment \
    --report-id-rsa report.id_rsa \
    --report-known-hosts report.known_hosts \
    --committer-name "Emory Merryman" \
    --committer-email emory.merryman@gmail.com &
