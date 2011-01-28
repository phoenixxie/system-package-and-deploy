#!/usr/bin/env python
import os
import stat
import sys
import re
import subprocess

def make_partition(device, boot = 100 * 1024, root = 30 * 1024 * 1024,
    var = 100 * 1024 * 1024, swap = 32 * 1024 * 1024):
  ''' make partitions and format the partitions '''

  if os.access(device, os.W_OK) == 0:
    print >> sys.stderr, device, ' should exist and be able to be written.'
    return False
  
  if (stat.S_IFBLK & os.stat(device).st_mode) == 0:
    print >> sys.stderr, device, ' should be a block device.'
    return False

  # wipe the mbr and fat of the disk
  block = open(device, 'wb')
  block.write(chr(0) * 512)
  block.close()

  # get the size of the disk
  pipe = subprocess.Popen("/usr/bin/env sfdisk -s " + device, shell = True, stdout = subprocess.PIPE)
  if pipe.wait() == 1:
    print >> sys.stderr, "Cannot get the size of " + device
    return False

  disksize = int(pipe.stdout.read())

  # get the geometry of the disk
  pipe = subprocess.Popen("/usr/bin/env sfdisk -g " + device, shell = True, stdout = subprocess.PIPE)
  if pipe.wait() == 1:
    print >> sys.stderr, "Cannot get the size of " + device
    return False

  geometry = pipe.stdout.read()
  match = re.match("^" + device + ": ([0-9]+) cylinders, ([0-9]+) heads, ([0-9]+) sectors/track$", geometry)
  cylinders = int(match.group(1))
  heads = int(match.group(2))
  sectors = int(match.group(3))

  unit = disksize / cylinders

  boot_unit = boot / unit
  if boot_unit == 0:
    boot_unit = 1

  root_unit = root / unit
  if root_unit == 0:
    root_unit = 1

  var_unit = var / unit
  if var_unit == 0:
    var_unit = 1

  swap_unit = swap / unit
  if swap_unit == 0:
    swap_unit = 1

  # make partitions
  command = '/usr/bin/env sfdisk -D ' + device + ''' << EOF
,%d,L,*
,%d,L,
,%d,L,
,,E,
,%d,S,
,,L,
EOF''' % (boot_unit, root_unit, var_unit, swap_unit)
  if subprocess.call(command, shell = True) != 0:
    print >> sys.stderr, "Make partitions error."
    return False

  # format disks
  command = "mkfs.ext3 -L /boot " + device + "1"
  if subprocess.call(command, shell = True) != 0:
    print >> sys.stderr, "Cannot format " + device + "1"
    return False
  command = "mkfs.ext3 -L / " + device + "2"
  if subprocess.call(command, shell = True) != 0:
    print >> sys.stderr, "Cannot format " + device + "2"
    return False
  command = "mkfs.ext3 -L /var " + device + "3"
  if subprocess.call(command, shell = True) != 0:
    print >> sys.stderr, "Cannot format " + device + "3"
    return False
  command = "mkswap " + device + "5"
  if subprocess.call(command, shell = True) != 0:
    print >> sys.stderr, "Cannot format " + device + "5"
    return False
  command = "mkfs.ext3 -L /home " + device + "6"
  if subprocess.call(command, shell = True) != 0:
    print >> sys.stderr, "Cannot format " + device + "6"
    return False

  return True

if __name__ == "__main__":
  if len(sys.argv) != 6:
    print >> sys.stderr, 'Usage: ', sys.argv[0], ' /dev/sdX boot_size root_size var_size swap_size'
    sys.exit(1)
  
  if make_partition(sys.argv[1], int(sys.argv[2]), int(sys.argv[3]),
      int(sys.argv[4]), int(sys.argv[5])) == False:
    print >> sys.stderr, "Cannot make partitions on " + sys.argv[1]
    sys.exit(1)
  
