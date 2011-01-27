#!/bin/sh

set -e

if [ ! $# -eq 3 ]; then
        echo Usage: $0 /dev/sdX /path/to/install/package/ /path/to/tarball/ 
        exit 1
fi

device=$1
deployroot=$2
tarball=$3

if [ ! -b ${device} ]; then
        echo ${device} should be a block device.
        exit 1
fi

if [ -d ${deployroot} ]; then
        echo ${deployroot} should not exists.
        exit 1
fi

if [ ! -e ${tarball} -o ! -f ${tarball} ]; then
	echo ${tarball} should exist and be a regular tarball.
	exit 1
fi

mkdir -p ${deployroot}
mount ${device}2 ${deployroot}
cd ${deployroot}
mkdir boot var home
mount ${device}1 boot
mount ${device}3 var
mount ${device}6 home

tar -xvp -f ${tarball} -C ${deployroot}/
rm -f ${deployroot}/etc/ssh/ssh_host_*

