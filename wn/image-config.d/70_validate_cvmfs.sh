#!/bin/bash

# oasis should be always present
# pick a well defined file, e.g. singularity
ls -l /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity
rc=$?

if [ $rc -ne 0 ]; then
  echo "Oasis CVMFS not found, retrying"
  sleep 5
  ls -l /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity
  rc=$?
fi

if [ $rc -ne 0 ]; then
  echo "Oasis CVMFS not found, retrying"
  sleep 15
  ls -l /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity
  rc=$?
fi

if [ $rc -ne 0 ]; then
  echo "Oasis CVMFS not found, retrying"
  sleep 45
  ls -l /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity
  rc=$?
fi

if [ $rc -ne 0 ]; then
  echo "Oasis CVMFS not found!"
  exit 1
fi

echo "# detected CVMFS mounts" > /etc/condor/config.d/10_cvmfs.conf
for d in `(cd /cvmfs && /usr/bin/ls -d *)`; do
  v=`echo $d | sed 's/\./_/g'`
  echo "HAS_CVMFS_$v=True" >> /etc/condor/config.d/10_cvmfs.conf
  echo 'STARTD_EXPRS = $(STARTD_EXPRS)' HAS_CVMFS_$v >> /etc/condor/config.d/10_cvmfs.conf
done

