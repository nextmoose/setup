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
		major)
		    shift &&
			git_thunder_repository_major "${@}" &&
			shift ${#}
		    ;;
		minor)
		    shift &&
			git_thunder_repository_minor "${@}" &&
			shift ${#}
		    ;;
		patch)
		    shift &&
			git_thunder_repository_patch "${@}" &&
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
	    mkdir "${HOME}/srv/repositories/${ORGANIZATION}/${NAME}"
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
    git_thunder_repository_major(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		create)
		    shift &&
			git_thunder_repository_major_create "${@}" &&
			shift ${#}
		    ;;
		list)
		    shift &&
			git_thunder_repository_major_list "${@}" &&
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
    git_thunder_repository_major_create(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--organization)
		    ORGANIZATION="${2}" &&
			shift 2
		    ;;
		--project)
		    PROJECT="${2}" &&
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
	    if [ -z "${PROJECT}" ]
	    then
		echo Unspecified major PROJECT &&
		    exit 65
	    elif [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified major ORGANIZATION &&
		    exit 66
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 67
	    elif [ -d "${HOME}/srv/repositories/${ORGANIZATION}/${NAME}" ]
	    then
		echo The project - ${ORGANIZATION}/${NAME} - already exists. &&
		    exit 68
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    HEAD=$(ls -1t "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" | head --lines 1) &&
	    if [ -z "${HEAD}" ]
	    then
		MAJOR=0
	    else
		MAJOR=$((${HEAD}+1))
	    fi
	    mkdir "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}"
    } &&
    git_thunder_repository_major_list(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--organization)
		    ORGANIZATION="${2}" &&
			shift 2
		    ;;
		--project)
		    PROJECT="${2}" &&
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
		echo Unspecified major ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified major PROJECT &&
		    exit 66
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    ls -1 "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}"
    } &&
    git_thunder_repository_minor(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		create)
		    shift &&
			git_thunder_repository_minor_create "${@}" &&
			shift ${#}
		    ;;
		list)
		    shift &&
			git_thunder_repository_minor_list "${@}" &&
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
    git_thunder_repository_minor_create(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--organization)
		    ORGANIZATION="${2}" &&
			shift 2
		    ;;
		--project)
		    PROJECT="${2}" &&
			shift 2
		    ;;
		--major)
		    MAJOR="${2}" &&
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
	    if [ -z "${PROJECT}" ]
	    then
		echo Unspecified minor PROJECT &&
		    exit 65
	    elif [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified minor ORGANIZATION &&
		    exit 66
	    elif [ -z "${MAJOR}" ]
	    then
		echo Unspecified minor MAJOR &&
		    exit 67
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 68
	    elif [ -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The project - ${ORGANIZATION}/${NAME} - already exists. &&
		    exit 69
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    HEAD=$(ls -1t "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" | head --lines 1) &&
	    if [ -z "${HEAD}" ]
	    then
		MAJOR=0
	    else
		MAJOR=$((${HEAD}+1))
	    fi
	    mkdir "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}"
    } &&
    git_thunder_repository_major_list(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		--organization)
		    ORGANIZATION="${2}" &&
			shift 2
		    ;;
		--project)
		    PROJECT="${2}" &&
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
		echo Unspecified major ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified major PROJECT &&
		    exit 66
	    fi &&
	    mkdir -p ${HOME}/srv/reposititories &&
	    ls -1 "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}"
    } &&
    git_thunder "${@}"
