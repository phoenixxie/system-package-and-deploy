#!/bin/sh

if [ ! $# -eq 1 ]; then
	echo Usage: $0 /path/to/be/cleared
	exit 1
fi

deployroot=$1

if [ ! -d ${deployroot} ]; then
	echo ${deployroot} should be a directory.
	exit 1
fi

cd /
umount ${deployroot}/boot
umount ${deployroot}/var
umount ${deployroot}/home
umount ${deployroot}/dev
umount ${deployroot}/sys
umount ${deployroot}/proc
umount ${deployroot}

rm -rf ${deployroot}
