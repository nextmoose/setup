#!/bin/sh

VM=nixos-$((${RANDOM}%9000+1000)) &&
    SSH_KEY=id_rsa &&
    VMDK=$(mktemp) &&
    ISONIX=$(mktemp $(pwd)/XXXXXXXX) &&
    PORT=27895 &&
    KNOWN_HOSTS=$(mktemp) &&
    rm -f ${SSH_KEY} ${VMDK} &&
    cleanup(){
	VBoxManage controlvm ${VM} poweroff soft &&
	    sleep 1m &&
	    VBoxManage unregistervm --delete ${VM} &&
	    sudo lvremove --force /dev/volumes/${VM} &&
	    rm -f ${ISONIX} ${KNOWN_HOSTS} &&
	    true
    } &&
    trap cleanup EXIT &&
    if [ ! -f ${SSH_KEY} ]
    then
	ssh-keygen -f ${SSH_KEY} -P "" -C ""
    fi &&
    sed \
	-e "s#ID_RSA.PUB#$(ssh-keygen -y -f id_rsa)#" \
	-e "w${ISONIX}" \
	iso.nix &&
    nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=${ISONIX} &&
    sudo lvcreate --name ${VM} --size 100GB volumes &&
    VBoxManage \
	internalcommands \
	createrawvmdk -filename  \
	${VMDK} \
	-rawdisk /dev/volumes/${VM} &&
    VBoxManage \
	createvm \
	--name ${VM} \
	--groups /nixos \
	--register &&
    VBoxManage storagectl ${VM} --name "SATA Controller" --add SATA &&
    VBoxManage \
	storageattach \
	${VM} \
	--storagectl "SATA Controller" \
	--port 0 \
	--device 0 \
	--type dvddrive \
	--medium $(pwd)/result/iso/nixos-18.03.133098.cd0cd946f37-x86_64-linux.iso &&
    VBoxManage storagectl ${VM} --name "IDE" --add IDE &&
    VBoxManage \
	storageattach \
	${VM} \
	--storagectl "IDE" \
	--port 0 \
	--device 0 \
	--type hdd \
	--medium ${VMDK} &&
    VBoxManage modifyvm "${VM}" --natpf1 "guestssh,tcp,127.0.0.1,${PORT},,22" &&
    VBoxManage modifyvm "${VM}" --nic1 nat &&
    echo SSH KEY=${SSH_KEY} &&
    echo PORT=${PORT} &&
    VBoxManage startvm ${VM} &&
    sleep 2m &&
    echo ${KNOWN_HOSTS} &&
    ssh-keyscan -p ${PORT} 127.0.0.1 > ${KNOWN_HOSTS} &&
    echo finished waiting for vm &&
    ssh -i ${SSH_KEY} -l root -p ${PORT} -o UserKnownHostsFile=${KNOWN_HOSTS} 127.0.0.1 hello
    true
