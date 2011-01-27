#!/bin/sh

set -e

if [ ! $# -eq 1 ]; then
	echo Usage: $0 /dev/sdX
	exit 1
fi

device=$1

if [ ! -b ${device} ]; then
	echo ${device} should be a block device.
	exit 1
fi

mkfs.ext3 -L /boot ${device}1
tune2fs -o user_xattr ${device}1
mkfs.ext3 -L / ${device}2
tune2fs -o user_xattr ${device}2
mkfs.ext3 -L /var ${device}3
tune2fs -o user_xattr ${device}3
mkfs.ext3 -L /home ${device}6
tune2fs -o user_xattr ${device}6
mkswap ${device}5
