#!/bin/bash

maxtries=15

mps=`cat /etc/mount-and-wait.mps`

# do not die on signal, try to complete
trap "echo Signal-Received" SIGTERM SIGINT

# cleanup
tries=0
for mp1 in $mps; do
   umount /cvmfs/${mp1}
   rc=$?
   while [ $rc -ne 0 ]; do
     sleep 1
     echo "Retrying unmounting ${mp1}"
     umount /cvmfs/${mp1}
     rc=$?
     let tries=1+$tries
     if [ $tries -ge $maxtries ]; then 
       break
     fi
   done
   rmdir /cvmfs/${mp1}
   echo "Unmounted ${mp1}"
done


pidk=`cat /etc/mount-and-wait.pid`
if [ "x${pidk}" != "x" ]; then
  # hard kill the waiting process, should not be doing anything but sleep
  kill -9 "$pidk"
else
  echo "WARNING: /etc/mount-and-wait.pid not found"
fi
