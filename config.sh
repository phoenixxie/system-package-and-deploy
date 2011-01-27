#!/bin/sh

set -e

boot_size=$((100 * 1024))
root_size=$((30 * 1024 * 1024))
var_size=$((100 * 1024 * 1024))
swap_size=$((32 * 1024 * 1024))

topdir=`pwd`
backupdir=${topdir}/backup
current=${backupdir}/current_tarball.txt

random=${RANDOM}

logfile=/tmp/deploy-${random}.log
errfile=/tmp/deploy-${random}.err

exec 1> ${logfile}
exec 2> ${errfile}
