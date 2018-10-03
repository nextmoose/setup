#!/bin/sh

export PATH=${PATH}:GIT:OPENSSH:GNUPG &&
    mkdir ${HOME}/.ssh &&
    chmod 0700 ${HOME}/.ssh &&
    (cat > ${HOME}/.ssh/config <<EOF
Host upstream
HostName github.com
User git
IdentityFile ${HOME}/.ssh/upstream.id_rsa
UserKnownHostsFile ${HOME}/.ssh/upstream.known_hosts

Host origin
HostName github.com
User git
IdentityFile ${HOME}/.ssh/origin.id_rsa
UserKnownHostsFile ${HOME}/.ssh/origin.known_hosts

Host report
HostName github.com
User git
IdentityFile ${HOME}/.ssh/report.id_rsa
UserKnownHostsFile ${HOME}/.ssh/report.known_hosts
EOF
    ) &&
    chmod 0600 ${HOME}/.ssh/config &&
    secrets upstream.id_rsa > ${HOME}/.ssh/upstream.id_rsa &&
    chmod 0600 ${HOME}/.ssh/upstream.id_rsa &&
    secrets upstream.known_hosts > ${HOME}/.ssh/upstream.known_hosts &&
    chmod 0600 ${HOME}/.ssh/upstream.known_hosts &&
    secrets origin.id_rsa > ${HOME}/.ssh/origin.id_rsa &&
    chmod 0600 ${HOME}/.ssh/origin.id_rsa &&
    secrets origin.known_hosts > ${HOME}/.ssh/origin.known_hosts &&
    chmod 0600 ${HOME}/.ssh/origin.known_hosts &&
    secrets report.id_rsa > ${HOME}/.ssh/report.id_rsa &&
    chmod 0600 ${HOME}/.ssh/report.id_rsa &&
    secrets report.known_hosts > ${HOME}/.ssh/report.known_hosts &&
    chmod 0600 ${HOME}/.ssh/report.known_hosts &&
    mkdir ${HOME}/project &&
    git -C ${HOME}/project init &&
    ln -sf OUT/bin/pre-push ${HOME}/project/.git/hooks &&
    ln -sf OUT/bin/post-commit ${HOME}/project/.git/hooks &&
    git -C ${HOME}/project config user.name "Emory Merryman" &&
    git -C ${HOME}/project config user.email "emory.merryman@gmail.com" &&
    git -C ${HOME}/project remote add upstream upstream:rebelplutonium/setup.git &&
    git -C ${HOME}/project remote set-url --push upstream no_push &&
    git -C ${HOME}/project remote add origin origin:nextmoose/setup.git &&
    git -C ${HOME}/project remote add nextmoose report:rebelplutonium/setup.git &&
    git -C ${HOME}/project fetch upstream master &&
    true
