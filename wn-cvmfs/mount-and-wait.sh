#!/bin/bash

if [ "x${SQUID_URI}" == "x" ]; then
  echo "Missing SQUID_URI" 1>&2
  exit 1
fi
echo "CVMFS_HTTP_PROXY=\"${SQUID_URI}\"" >/etc/cvmfs/default.local


if [ "x${QUOTA_LIMIT}" != "x" ]; then
  echo "CVMFS_QUOTA_LIMIT=${QUOTA_LIMIT}" >> /etc/cvmfs/default.local
fi


if [ "x${MOUNT_REPOS}" == "x" ]; then
  echo "Missing MOUNT_REPOS" 1>&2
  exit 1
fi

# do not die on signal, try to complete
trap "echo Signal-Received" SIGTERM SIGINT

mps=""
for mp in `echo ${MOUNT_REPOS} |tr , ' '` ; do 
 mkdir /cvmfs/${mp}
 mount -t cvmfs ${mp} /cvmfs/${mp}
 rc=$?
 if [ ${rc} -eq 0 ] ; then
   mps="$mp $mps" #save them in reverse order
 else
   echo "Failed to mount $mp" 1>&2

   # cleanup
   for mp1 in $mps; do
     umount /cvmfs/${mp1}
   done
   exit 2
 fi
done

echo "$mps" > /etc/mount-and-wait.mps

echo "CVMFS mountpoints started: $mps"
/usr/local/sbin/wait-only.sh
echo "Terminating"

# cleanup

# first try the proper way
for mp1 in $mps; do
   if [ -d /cvmfs/${mp1} ]; then
     umount /cvmfs/${mp1}
     rc=$?
     if [ $rc -ne 0 ]; then
       echo "Failed unmounting ${mp1}"
     else
       rmdir /cvmfs/${mp1}
       echo "Unmounted ${mp1}"
     fi
   fi
done

# now do a pass with the most fail-safe option possible
for mp1 in $mps; do
  echo "Attempting lazy umount of ${mp1}"
  umount -l /cvmfs/${mp1}
  if [ $? -eq 0 ]; then 
   echo "Lazy unmounted ${mp1}"
  fi
done

# wait a tiny bit to make sure everything is cleaned up properly
sleep 2

echo "Bye"

