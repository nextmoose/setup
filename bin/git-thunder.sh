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
	    working)
		shift &&
		    git_thunder_working "${@}" &&
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
		project)
		    shift &&
			git_thunder_repository_project "${@}" &&
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
	    elif [ -d "${HOME}/srv/repositories/${NAME}" ]
	    then
		echo The organization - ${NAME} - already exists. &&
		    exit 66
	    fi &&
	    mkdir -p "${HOME}/srv/repositories" &&
	    mkdir "${HOME}/srv/repositories/${NAME}"
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
	    mkdir -p "${HOME}/srv/repositories" &&
	    ls -1 "${HOME}/srv/repositories"
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
	    elif [ ! -d "${HOME}/srv/repositories/${NAME}" ]
	    then
		echo The organization - ${NAME} - does not exist. &&
		    exit 66
	    fi &&
	    mkdir -p ${HOME}/srv/repositories &&
	    rm --recursive ${FORCE} "${HOME}/srv/repositories/${NAME}"
    } &&
    git_thunder_repository_project(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		create)
		    shift &&
			git_thunder_repository_project_create "${@}" &&
			shift ${#}
		    ;;
		list)
		    shift &&
			git_thunder_repository_project_list "${@}" &&
			shift ${#}
		    ;;
		remove)
		    shift &&
			git_thunder_repository_project_remove "${@}" &&
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
    git_thunder_repository_project_create(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--organization)
		    ORGANIZATION="${2}" &&
			shift 2
		    ;;
		--name)
		    NAME="${2}" &&
			shift 2
		    ;;
		--user-name)
		    USER_NAME="${2}" &&
			shift 2
		    ;;
		--user-email)
		    USER_EMAIL="${2}" &&
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
		echo Unspecified project NAME &&
		    exit 65
	    elif [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified project ORGANIZATION &&
		    exit 66
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 67
	    elif [ -d "${HOME}/srv/repositories/${ORGANIZATION}/${NAME}" ]
	    then
		echo The project - ${ORGANIZATION}/${NAME} - already exists. &&
		    exit 68
	    elif [ -z "${USER_NAME}" ]
	    then
		echo Unspecified project USER_NAME &&
		    exit 69
	    elif [ -z "${USER_EMAIL}" ]
	    then
		echo Unspecified project USER_EMAIL &&
		    exit 69
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    mkdir "${HOME}/srv/repositories/${ORGANIZATION}/${NAME}" &&
	    git -C "${HOME}/srv/repositories/${ORGANIZATION}/${NAME}" init --bare &&
	    WORK_DIR=$(mktemp -d) &&
	    git -C "${WORK_DIR}" init &&
	    git -C "${WORK_DIR}" remote add origin "${HOME}/srv/repositories/${ORGANIZATION}/${NAME}" &&
	    touch "${WORK_DIR}/.gitignore" &&
	    git -C "${WORK_DIR}" add .gitignore &&
	    git -C "${WORK_DIR}" config user.name "${USER_NAME}" &&
	    git -C "${WORK_DIR}" config user.name "${USER_NAME}" &&
	    git -C "${WORK_DIR}" commit --message "initial commit" &&
	    git -C "${WORK_DIR}" push origin master &&
	    rm -rf ${WORK_DIR}
    } &&
    git_thunder_repository_project_list(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--organization)
		    ORGANIZATION="${2}" &&
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
	    if [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified project ORGANIZATION &&
		    exit 65
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    ls -1 "${HOME}/srv/repositories/${ORGANIZATION}"
    } &&
    git_thunder_repository_project_remove(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--organization)
		    ORGANIZATION="${2}" &&
			shift 2
		    ;;
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
		echo Unspecified project NAME &&
		    exit 65
	    elif [ -z "${ORGANIZATION}" ]
	    then
		 echo unspecified project ORGANIZATION &&
		     exit 66
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		 echo The specified organization - ${ORGANIZATION} - does not exist. &&
		     exit 67
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		 echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		     exit 68
	    fi &&
	    mkdir -p "${HOME}/srv/repositories" &&
	    rm --recursive ${FORCE} "${HOME}/srv/repositories/${ORGANIZATION}/${NAME}"
    } &&
    git_thunder "${@}"
