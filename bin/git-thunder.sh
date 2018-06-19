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
		echo Unspecified organization ORGANIZATION &&
		    exit 65
	    elif [ -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The organization - ${ORGANIZATION} - already exists. &&
		    exit 66
	    fi &&
	    mkdir "${HOME}/srv/repositories/${ORGANIZATION}"
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
	    ls -1 "${HOME}/srv/repositories"
    } &&
    git_thunder_repository_organization_remove(){
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
		echo Unspecified organization ORGANIZATION &&
		    exit 65
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The organization - ${ORGANIZATION} - does not exist. &&
		    exit 66
	    fi &&
	    rm --recursive "${HOME}/srv/repositories/${ORGANIZATION}"
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
		echo Unspecified project ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified project PROJECT &&
		    exit 66
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 67
	    elif [ -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The project - ${ORGANIZATION}/${PROJECT} - already exists. &&
		    exit 68
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
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 66
	    fi &&
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
		echo Unspecified project ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		 echo unspecified project PROJECT &&
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
	    if [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified major ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified major PROJECT &&
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
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    echo 67
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		    echo 68
	    fi &&
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
	    if [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified minor ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified minor PROJECT &&
		    exit 66
	    elif [ -z "${MAJOR}" ]
	    then
		echo Unspecified minor MAJOR &&
		    exit 67
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 68
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		    exit 69
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" ]
	    then
		echo The specified major - ${ORGANIZATION}/${PROJECT}/${MAJOR} - does not exist. &&
		    exit 70
	    fi &&
	    HEAD=$(ls -1t "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" | head --lines 1) &&
	    if [ -z "${HEAD}" ]
	    then
		MINOR=0
	    else
		MINOR=$((${HEAD}+1))
	    fi
	    mkdir "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR}"
    } &&
    git_thunder_repository_minor_list(){
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
	    if [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified minor ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified minor PROJECT &&
		    exit 66
	    elif [ -z "${MAJOR}" ]
	    then
		echo Unspecified minor MAJOR &&
		    exit 67
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 68
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		    exit 69
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" ]
	    then
		echo The specified major - ${ORGANIZATION}/${PROJECT}/${MAJOR} - does not exist. &&
		    exit 70
	    fi &&
	    ls -1 "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}"
    } &&
    git_thunder_repository_patch(){
	while [ ${#} -gt 0 ]
	do
	    case ${1} in
		create)
		    shift &&
			git_thunder_repository_patch_create "${@}" &&
			shift ${#}
		    ;;
		list)
		    shift &&
			git_thunder_repository_patch_list "${@}" &&
			shift ${#}
		    ;;
		init)
		    shift &&
			git_thunder_repository_patch_init "${@}" &&
			shift ${#}
		    ;;
		link)
		    shift &&
			git_thunder_repository_patch_link "${@}" &&
			shift ${#}
		*)
		    echo Unknown Option &&
			echo ${0} &&
			echo ${@} &&
			exit 64
		    ;;
	    esac
	done
    } &&
    git_thunder_repository_patch_create(){
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
		--minor)
		    MINOR="${2}" &&
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
		echo Unspecified patch ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified patch PROJECT &&
		    exit 66
	    elif [ -z "${MAJOR}" ]
	    then
		echo Unspecified patch MAJOR &&
		    exit 67
	    elif [ -z "${MINOR}" ]
	    then
		echo Unspecified patch MINOR &&
		    exit 68
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 69
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		    exit 70
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" ]
	    then
		echo The specified major - ${ORGANIZATION}/${PROJECT}/${MAJOR} - does not exist. &&
		    exit 71
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR}" ]
	    then
		echo The specified minor - ${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR} - does not exist. &&
		    exit 72
	    fi &&
	    HEAD=$(ls -1t "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" | head --lines 1) &&
	    if [ -z "${HEAD}" ]
	    then
		PATCH=0
	    else
		PATCH=$((${HEAD}+1))
	    fi &&
	    mkdir "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR}/${PATCH}"
    } &&
    git_thunder_repository_patch_list(){
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
		--minor)
		    MINOR="${2}" &&
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
		echo Unspecified patch ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified patch PROJECT &&
		    exit 66
	    elif [ -z "${MAJOR}" ]
	    then
		echo Unspecified patch MAJOR &&
		    exit 67
	    elif [ -z "${MINOR}" ]
	    then
		echo Unspecified patch MINOR &&
		    exit 68
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 69
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		    exit 70
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" ]
	    then
		echo The specified major - ${ORGANIZATION}/${PROJECT}/${MAJOR} - does not exist. &&
		    exit 71
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR}" ]
	    then
		echo The specified patch - ${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR} - does not exist. &&
		    exit 71
	    fi &&
	    ls -1 "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR}"
    } &&
    git_thunder_repository_patch_init(){
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
	    if [ -z "${ORGANIZATION}" ]
	    then
		echo Unspecified patch ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified patch PROJECT &&
		    exit 66
	    elif [ -z "${MAJOR}" ]
	    then
		echo Unspecified patch MAJOR &&
		    exit 67
	    elif [ -z "${USER_NAME}" ]
	    then
		echo Unspecified patch USER_NAME &&
		    exit 68
	    elif [ -z "${USER_EMAIL}" ]
	    then
		echo Unspecified patch USER_EMAIL &&
		    exit 69
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 70
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		    exit 71
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" ]
	    then
		echo The specified major - ${ORGANIZATION}/${PROJECT}/${MAJOR} - does not exist. &&
		    exit 72
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/0" ]
	    then
		echo The specified minor - ${ORGANIZATION}/${PROJECT}/${MAJOR}/0 - does not exist. &&
		    exit 73
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0" ]
	    then
		echo The specified patch - ${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0 - does not exist. &&
		    exit 74
	    elif [ -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0/.git" ]
	    then
		echo The specified patch - ${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0 - has already been started. &&
		    exit 75
	    fi &&
	    WORK_DIR=$(mktemp -d) &&
	    git -C ${WORK_DIR} init &&
	    git -C ${WORK_DIR} config user.name "${USER_NAME}" &&
	    git -C ${WORK_DIR} config user.email "${USER_EMAIL" &&
	    git -C ${WORK_DIR} remote add origin "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/${MINOR}/${PATCH}" &&
	    git -C ${WORK_DIR} commit --message "initial commit" &&
	    git -C ${WORK_DIR} push origin master &&
	    rm --recursive ${WORK_DIR}
    } &&
    git_thunder_repository_patch_link(){
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
		--ancestor-major)
		    ANCESTOR_MAJOR="${2}" &&
			shift 2
		    ;;
		--ancestor-minor)
		    ANCESTOR_MINOR="${2}" &&
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
		echo Unspecified patch ORGANIZATION &&
		    exit 65
	    elif [ -z "${PROJECT}" ]
	    then
		echo Unspecified patch PROJECT &&
		    exit 66
	    elif [ -z "${MAJOR}" ]
	    then
		echo Unspecified patch MAJOR &&
		    exit 67
	    elif [ -z "${ANCESTOR_MAJOR}" ]
	    then
		echo Unspecified patch ANCESTOR_MAJOR &&
		    exit 68
	    elif [ -z "${ANCESTOR_MINOR}" ]
	    then
		echo Unspecified patch ANCESTOR_MINOR &&
		    exit 69
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}" ]
	    then
		echo The specified organization - ${ORGANIZATION} - does not exist. &&
		    exit 70
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}" ]
	    then
		echo The specified project - ${ORGANIZATION}/${PROJECT} - does not exist. &&
		    exit 71
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}" ]
	    then
		echo The specified major - ${ORGANIZATION}/${PROJECT}/${MAJOR} - does not exist. &&
		    exit 72
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/0" ]
	    then
		echo The specified minor - ${ORGANIZATION}/${PROJECT}/${MAJOR}/0 - does not exist. &&
		    exit 73
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0" ]
	    then
		echo The specified patch - ${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0 - does not exist. &&
		    exit 74
	    elif [ -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0/.git" ]
	    then
		echo The specified patch - ${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0 - has already been started. &&
		    exit 75
	    elif [ ${MAJOR} -lt ${ANCESTOR_MAJOR} ]
	    then
		echo The specified ancestor major - ${ANCESTOR_MAJOR} - is not prior to the specified major - ${MAJOR} &&
		    exit 76
	    elif [ ! -d "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${ANCESTOR_MAJOR}/${ANCESTOR_MINOR}" ]
	    then
		echo The specified minor ancestor ${ORGANIZATION}/${PROJECT}/${ANCESTOR_MAJOR}/${ANCESTOR_MINOR} does not exist. &&
		    exit 77
	    fi &&
	    ANCESTOR_PATCH=$(ls -1 "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${ANCESTOR_MAJOR}/${ANCESTOR_MINOR}" | head --lines 1) &&
	    if [ ! -z "${ANCESTOR_PATCH}" ]
	    then
		WORK_DIR=$(mktemp -d) &&
		    git -C ${WORK_DIR} init &&
		    git -C ${WORK_DIR} remote add ancestor "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${ANCESTOR_MAJOR}/${ANCESTOR_MINOR}/${ANCESTOR_PATCH}" &&
		    git -C ${WORK_DIR} remote add origin "${HOME}/srv/repositories/${ORGANIZATION}/${PROJECT}/${MAJOR}/0/0" &&
		    git -C ${WORK_DIR} fetch ancestor master &&
		    git -C ${WORK_DIR} push origin master &&
		    rm --recursive ${WORK_DIR}
	    fi
    } &&
    mkdir -p ${HOME}/srv/reposititories &&
    git_thunder "${@}"
