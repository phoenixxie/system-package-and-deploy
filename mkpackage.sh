#!/bin/sh

set -e

. config.sh new

tar --exclude /dev --exclude /proc --exclude /mnt --exclude /tmp --exclude /sys --exclude /etc/ssh/ssh_host_* --exclude=*lost+found --exclude ${backupdir} -cvp -f ${tarball} /

echo `basename ${tarball}` > ${current}
