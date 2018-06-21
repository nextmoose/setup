#!/bin/sh

gpg --import private/gpg.secret.key &&
    gpg --import-ownertrust gpg.ownertrust &&
    pass git init &&
