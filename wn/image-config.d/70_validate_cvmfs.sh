#!/bin/bash

# oasis should be always present
# pick a well defined file, e.g. singularity
ls -l /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity
rc=$?

if [ $rc -ne 0 ]; then
  echo "Oasis CVMFS not found!"
  exit 1
fi
