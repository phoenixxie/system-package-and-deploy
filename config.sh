#!/bin/sh

set -e

topdir=`dirname $0`
cd ${topdir}
topdir=`pwd`

backupdir=${topdir}/backup
if [ ! -e ${backupdir} ]; then
	mkdir -p ${backupdir}
fi

random=${RANDOM}
deployroot=/tmp/deploy-${random}
current=${backupdir}/current_tarball.txt
suffix=`date +%Y%m%d%H%M%S`$random

if [ "${tarball+set}" != set ]; then
	if [ $# -eq 1 -a "$1" = "new" ]; then
		tarball=${backupdir}/system-${suffix}.tar
	else
		if [ ! -e ${current} -o ! -f ${current} -o ! -s ${current} ]; then
			echo ${current} shoule exist and be a regular file.
			exit 1
		fi
		tarball=${backupdir}/`cat ${current}`
	fi
fi

logfile=/tmp/deploy-${random}.log
errfile=/tmp/deploy-${random}.err

exec 1> ${logfile}
exec 2> ${errfile}
