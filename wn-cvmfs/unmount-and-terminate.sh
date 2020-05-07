#!/bin/bash

maxtries=15

mps=`cat /etc/mount-and-wait.mps`

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
  kill "$pidk"
else
  echo "WARNING: /etc/mount-and-wait.pid not found"
fi
