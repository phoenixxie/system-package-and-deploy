#!/bin/sh

set -e

. config.sh

if [ ! -e ${backupdir} ]; then
  mkdir -p ${backupdir}
fi

suffix=`date +%Y%m%d%H%M%S`$random
tarball=${backupdir}/system-${suffix}.tar

tar --exclude /dev --exclude /proc --exclude /mnt --exclude /tmp --exclude /sys --exclude /etc/ssh/ssh_host_* --exclude=*lost+found --exclude ${backupdir} -cvp -f ${tarball} /

echo `basename ${tarball}` > ${current}
