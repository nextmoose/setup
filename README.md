# Setup

Setup my computer environment.
This project is built for my exclusive use, but you may/may not find it useful anyway.

## Getting Started

### Prequisitives
1. Download the install iso file https://getfedora.org/
2. Install "Fedora Media Writer".
3. Use Fedora Media Writer
4. Generate gpg secret keys.
5. Store them as plain text files in 'gpg.secret.key' and 'gpg2.secret.key' respectively.
6. Update 'gpg.owner.trust' and 'gpg2.owner.trust' as well.


### Installing
1. Put the USB disk in.
2. Make sure that BIOS boots on USB disk in high priority.
3. Reboot and let the Installer Work.
4. Configure your drive structure like ... do not use LVM except where noted
   1. /root 64GB
   2. /home 1GB
   3. /tmp 1GB
   4. /var/tmp 1GB
   5. /var/log 1GB
   6. /run/docker/encrypted 1GB
   7. /run/docker/unencrypted 1GB
   8. /var/reserve/volumes LVM (ALL REMAINING SPACE) create volume group docker

### Post Installation
1. Run `sh native/fedora/28/setup.sh`