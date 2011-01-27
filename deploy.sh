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

echo Making partitions on ${device}...
${topdir}/mkpart.sh ${device}

echo Making filesystems on ${device}...
${topdir}/mkfs.sh ${device}

echo Deploying files...
${topdir}/deployfile.sh ${device} ${deployroot} ${tarball}

echo Installing grub...
${topdir}/installgrub.sh ${device} ${deployroot}

echo Clearing...
${topdir}/clear.sh ${deployroot}
