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
echo "$$" > /etc/mount-and-wait.pid

echo "CVMFS mountpoints started: $mps"
sleep infinity
echo "Terminating"

# cleanup, if I can
for mp1 in $mps; do
   umount /cvmfs/${mp1}
done
echo "Bye"

