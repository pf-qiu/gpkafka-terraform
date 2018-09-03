#!/bin/bash
mkfs.ext4 /dev/nvme0n1
mkdir /data
mount /dev/nvme0n1 /data
chown gpadmin:gpadmin /data
echo "500 1024000 200 4096" > /proc/sys/kernel/sem