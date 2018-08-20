#!/bin/sh

_github(){
    local CUR &&
	COMPREPLY=() &&
	CUR=${COMP_WORDS[COMP_CWORD]} &&
	case "${CUR}" in
	    -*)
		COMPREPLY=($(compgen -W "--upstream-host --upstream-port --upstream-user --upstream-organization --upstream-repository --upstream-branch --origin-host --origin-port --origin-user --origin-organization --origin-repository --origin-branch --report-host --report-port --report-user --report-organization --report-repository --report-branch --committer-name --committer-email" -- ${CUR}))
		;;
	esac &&
	return 0
} &&
    complete -F _github -o filenames github
