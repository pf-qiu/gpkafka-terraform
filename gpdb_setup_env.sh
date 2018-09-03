#!/bin/bash
mkfs.ext4 /dev/nvme0n1
mkdir /data
mount /dev/nvme0n1 /data
chown gpadmin:gpadmin /data
