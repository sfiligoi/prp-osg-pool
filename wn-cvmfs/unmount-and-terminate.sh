#!/bin/bash

mps=`cat /etc/mount-and-wait.mps`
for mp in $mps; do
  umount /cvmfs/$mp
done

pidk=`cat /etc/mount-and-wait.pid`
if [ "x${pidk}" != "x" ]; then
  kill "$pidk"
else
  echo "WARNING: /etc/mount-and-wait.pid not found"
fi
