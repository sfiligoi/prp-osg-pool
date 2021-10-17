#!/bin/bash

# condor will use the wrapper /usr/bin/singularity_npid.sh
if [ -f "/usr/bin/singularity_npid.sh" ]; then
  # only test for singularity functionality if singularity is present
  # may not be in all pods

  /usr/bin/singularity_npid.sh exec --contain --ipc --pid --bind /cvmfs /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-el7:latest /usr/bin/dc -e "3 5 + p"
  rc=$?

  if [ $rc -ne 0 ]; then
    echo "Singularity test execution failed!"
    exit 1
  fi
fi
