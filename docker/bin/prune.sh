#!/bin/sh

sudo docker container rm --force --volumes $(sudo docker container ls --quiet --all)
