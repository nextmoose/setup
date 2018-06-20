#!/bin/sh

rm -rf ${HOME}/bin &&
    mkdir -p ${HOME}/bin &&
    cp bin/git-thunder.sh ${HOME}/bin/git-thunder &&
    rm -rf ${HOME}/srv &&
    git thunder repository organization create --organization acme &&
    git thunder repository project create --organization acme --project motor &&
    git thunder repository major create --organization acme --project motor &&
    git thunder repository minor create --organization acme --project motor --major 0 &&
    git thunder repository patch create --organization acme --project motor --major 0 --patch 0 &&
    git thunder repository patch link --organization acme --project motor --major 0
    true
