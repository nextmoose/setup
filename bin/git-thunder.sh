#!/bin/sh

git_thunder() {
    while [ ${#} -gt 0 ]
    do
	case ${1} in
	    repository)
		shift &&
		    git_thunder_repository "${@}" &&
		    shift ${#}
		;;
	    
	    *)
		echo Unknown Option &&
		    echo ${0} &&
		    echo ${@} &&
		    exit 64
		;;
	esac
    done
} &&
    git_thunder_repository() {
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		organization)
		    shift &&
			git_thunder_repository_organization "${@}" &&
			shift ${#}
		    ;;
		*)
		    echo Unknown Option &&
			echo ${0} &&
			echo ${@} &&
			exit 64
		    ;;
	    esac
	done
    } &&
    git_thunder_repository_organization(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		create)
		    shift &&
			git_thunder_repository_organization_create "${@}" &&
			shift ${#}
		    ;;
		list)
		    shift &&
			git_thunder_repository_organization_list "${@}" &&
			shift ${#}
		    ;;
		remove)
		    shift &&
			git_thunder_repository_organization_remove "${@}" &&
			shift ${#}
		    ;;
		*)
		    echo Unknown Option &&
			echo ${0} &&
			echo ${@} &&
			exit 64
		    ;;
	    esac
	done
    } &&
    git_thunder_repository_organization_create(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--name)
		    NAME="${2}" &&
			shift 2
		    ;;
		*)
		    echo Unknown Option &&
			echo ${0} &&
			echo ${@} &&
			exit 64
		    ;;
	    esac
	done &&
	    if [ -z "${NAME}" ]
	    then
		echo Unspecified organization NAME &&
		    exit 65
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    if [ -d ${HOME}/srv/repositories/${NAME} ]
	    then
		echo The organization - ${NAME} - already exists. &&
		    exit 66
	    fi &&
	    mkdir ${HOME}/srv/repositories/${NAME}
    } &&
    git_thunder_repository_organization_list(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		*)
		    echo Unknown Option &&
			echo ${0} &&
			echo ${@} &&
			exit 64
		    ;;
	    esac
	done &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    ls -1 ${HOME}/srv/repositories
    } &&
    git_thunder_repository_organization_remove(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--name)
		    NAME="${2}" &&
			shift 2
		    ;;
		--force)
		    FORCE=--force &&
			shift
		    ;;
		*)
		    echo Unknown Option &&
			echo ${0} &&
			echo ${@} &&
			exit 64
		    ;;
	    esac
	done &&
	    if [ -z "${NAME}" ]
	    then
		echo Unspecified organization NAME &&
		    exit 65
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    if [ ! -d ${HOME}/srv/repositories/${NAME} ]
	    then
		echo The organization - ${NAME} - does not exist. &&
		    exit 66
	    fi &&
	    rm --recursive ${FORCE} ${HOME}/srv/repositories/${NAME}
    } &&
    git_thunder "${@}"
