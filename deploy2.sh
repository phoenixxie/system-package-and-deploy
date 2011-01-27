#!/bin/sh

set -e

if [ ! $# -eq 1 ]; then
	echo Usage: $0 /dev/sdX [/path/to/tarball]
	exit 1
fi

device=$1

if [ ! -b ${device} ]; then
	echo ${device} should be a block device.
	exit 1
fi

if [ $# -eq 2 ]; then
	if [ -e $2 -a -f $2 ]; then
		tarball=$2
	fi
fi

. config.sh

deployroot=/tmp/deploy-${random}

if [ "${tarball+set}" != set ]; then
  if [ ! -e ${current} -o ! -f ${current} -o ! -s ${current} ]; then
    echo ${current} shoule exist and be a regular file.
    exit 1
  fi
  tarball=${backupdir}/`cat ${current}`
fi

echo Making partitions on ${device}...
python ${topdir}/filesystem.py ${device}

echo Deploying files...
${topdir}/deployfile.sh ${device} ${deployroot} ${tarball}

echo Installing grub...
${topdir}/installgrub.sh ${device} ${deployroot}

echo Clearing...
${topdir}/clear.sh ${deployroot}
