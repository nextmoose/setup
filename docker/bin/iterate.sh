#!/bin/sh

git fetch origin scratch/e01d29e9-4a85-443b-9ae2-6a162df69514 &&
    git checkout origin/scratch/e01d29e9-4a85-443b-9ae2-6a162df69514 &&
    sh docker/bin/prune.sh &&
    sh docker/bin/build.sh &&
    true