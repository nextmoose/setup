#!/bin/sh

VM=nixos-$((${RANDOM}%9000+1000)) &&
    SSH_KEY=$(mktemp) &&
    VMDK=$(mktemp) &&
    ISONIX=$(mktemp $(pwd)/XXXXXXXX) &&
    rm -f ${SSH_KEY} ${VMDK} &&
    cleanup(){
	VBoxManage controlvm ${VM} poweroff soft &&
	    sleep 1m &&
	    VBoxManage unregistervm --delete ${VM} &&
	    VBoxManager natnetwork --remove ${VM} &&
	    sudo lvremove --force /dev/volumes/${VM} &&
	    rm -f ${SSH_KEY} ${ISONIX} &&
	    true
    } &&
    trap cleanup EXIT &&
    ssh-keygen -f ${SSH_KEY} -P "" -C "" &&
    sed \
	-e "s#ID_RSA.PUB#$(cat ${SSH_KEY}.pub)#" \
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
    VBoxManage \
	natnetwork \
	add \
	--netname ${VM} \
	--network 10.0.0.0/8 \
	--enable &&
    VBoxManage startvm ${VM} &&
    read -p "IS THE VERSION MACHINE READY?  " READ1 &&
    ssh -i ${ID_RSA} -l root 64.137.201.46 hello &&
    read -p "IS THE TESTING COMPLETE?  " READ1 &&
    true
