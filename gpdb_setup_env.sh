#!/bin/bash
mkdir /data
mount -t ramfs ramfs /data
chown gpadmin:gpadmin /data
echo "500 1024000 200 4096" > /proc/sys/kernel/sem