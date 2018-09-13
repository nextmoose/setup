#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
	--destination)
	    DESTINATION="${2}" &&
		shift 2
	    ;;
	--containers)
	    CONTAINERS="${2}" &&
		shift 2
	*)
	    echo Unknown Option &&
		echo ${1} &&
		echo ${0} &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done &&
    (cat > ${DESTINATION}/containers.nix <<EOF
{
  containers = {
EOF
    ) &&
    if [ "${CONTAINERS}" ]
    then
	ls -1 configuration/containers | while read FILE
	do
	    echo "${FILE%.*} = (import ./containers/${FILE});" >> ${DESTINATION}/containers.nix
	done
    fi &&
    (cat >> ${DESTINATION}containers.nix <<EOF
  };
}
EOF
     )
    
