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

dd if=/dev/zero of=${device} bs=512 count=1

# sda1 /boot 100m
# sda2 /     30000m
# sda3 /var  100000m
# sda5 swap  32000m
# sda6 /home (rest)

fdisk ${device} << EOF
n
p
1

+100m
n
p
2

+30000m
n
p
3

+100000m
n
e


n

+32000m
n


a
1
t
1
83
t
2
83
t
3
83
t
5
82
t
6
83
w
EOF

