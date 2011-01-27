#!/bin/sh

set -e

if [ ! $# -eq 2 ]; then
	echo Usage: $0 /dev/sdX /path/to/install/grub
	exit 1
fi

device=$1
deployroot=$2

if [ ! -b ${device} ]; then
	echo ${device} should be a block device.
	exit 1
fi

if [ ! -d ${deployroot} ]; then
	echo ${deployroot} should be a directory.
	exit 1
fi

cd ${deployroot}
mkdir -p mnt dev proc tmp sys dev/shm dev/pts
chmod 1777 tmp
mount -o bind /dev dev
mount -t proc none proc
mount -t sysfs none sys

cat << EOF > ${deployroot}/tmp/grub.sh
#!/bin/sh
grub --batch << GRUB_EOF
device (hd0) ${device}
root (hd0,0)
embed /grub/e2fs_stage1_5 (hd0)
install (hd0,0)/grub/stage1 (hd0) (hd0)1+15 p (hd0,0)/grub/stage2 (hd0,0)/grub/grub.conf
GRUB_EOF
EOF

chmod +x ${deployroot}/tmp/grub.sh
chroot ${deployroot} /tmp/grub.sh
rm -f ${deployroot}/tmp/grub.sh
