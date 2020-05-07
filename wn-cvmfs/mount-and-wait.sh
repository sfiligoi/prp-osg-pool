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
need_cleanup=1
while [ ${need_cleanup} -eq 1 ]; then
  need_cleanup=0
  for mp1 in $mps; do
   if [ -d /cvmfs/${mp1} ]; then
     umount /cvmfs/${mp1}
     rc=$?
     if [ $rc -ne 0 ]; then
       need_cleanup=1
       echo "Failed unmounting ${mp1}"
     else
       rmdir /cvmfs/${mp1}
       echo "Unmounted ${mp1}"
    fi
  done
  if [ ${need_cleanup} -eq 1 ]; then
     sleep 1
  fi
done
echo "Bye"

