#!/bin/bash

CVMFS_REPOS=$1

while [ 1 -lt 2 ]; do 
  # loop forever
  for d in `echo ${CVMFS_REPOS} |tr , ' '` ; do
    if [ ! -d "/cvmfs/${d}" ]; then
      echo "ERROR: `date` Not mounted: /cvmfs/${d}. "
      condor_off -master -fast 
      exit 1
    fi
    if [ "`ls /cvmfs/${d} |wc -l`" -lt 2 ]; then
      echo "ERROR: `date` Empty dir: /cvmfs/${d}. " 
      condor_off -master -fast
      exit 1
    fi
  done

  sleep 30
done

