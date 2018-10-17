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
    mkdir ${HOME}/projects &&
    mkdir ${HOME}/projects/nixos-install &&
    git -C ${HOME}/projects/nixos-install init &&
    ln -sf OUT/bin/pre-push ${HOME}/projects/nixos-install/.git/hooks &&
    ln -sf OUT/bin/post-commit ${HOME}/projects/nixos-install/.git/hooks &&
    git -C ${HOME}/projects/nixos-install config user.name "Emory Merryman" &&
    git -C ${HOME}/projects/nixos-install config user.email "emory.merryman@gmail.com" &&
    git -C ${HOME}/projects/nixos-install remote add upstream upstream:rebelplutonium/nixos-install.git &&
    git -C ${HOME}/projects/nixos-install remote set-url --push upstream no_push &&
    git -C ${HOME}/projects/nixos-install remote add origin origin:nextmoose/nixos-install.git &&
    git -C ${HOME}/projects/nixos-install remote add nextmoose report:rebelplutonium/nixos-install.git &&
    git -C ${HOME}/projects/nixos-install fetch upstream master &&
    mkdir ${HOME}/projects/nixos-configuration &&
    git -C ${HOME}/projects/nixos-configuration init &&
    ln -sf OUT/bin/pre-push ${HOME}/projects/nixos-configuration/.git/hooks &&
    ln -sf OUT/bin/post-commit ${HOME}/projects/nixos-configuration/.git/hooks &&
    git -C ${HOME}/projects/nixos-configuration config user.name "Emory Merryman" &&
    git -C ${HOME}/projects/nixos-configuration config user.email "emory.merryman@gmail.com" &&
    git -C ${HOME}/projects/nixos-configuration remote add upstream upstream:NixOS/nixos-configuration.git &&
    git -C ${HOME}/projects/nixos-configuration remote set-url --push upstream no_push &&
    git -C ${HOME}/projects/nixos-configuration remote add origin origin:nextmoose/nixos-configuration.git &&
    git -C ${HOME}/projects/nixos-configuration remote add nextmoose report:NixOS/nixos-configuration.git &&
    git -C ${HOME}/projects/nixos-configuration fetch upstream master &&
    true
