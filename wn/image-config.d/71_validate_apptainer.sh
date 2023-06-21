#!/bin/bash

if [ "x${USE_SINGULARITY}" == "xno" ]; then
  rm -f /usr/bin/apptainer
elif [ "x${USE_SINGULARITY}" == "xnpid" ]; then
  # remove any local version
  rm -f /usr/bin/apptainer
  # use the npid version, whch relies on cvmfs singularity
  ln -s  /usr/bin/apptainer_npid.sh /usr/bin/apptainer
fi
# else do nothing, let Condor figure it out

if [ -f "/usr/bin/apptainer" ]; then
  # check if we need to test nvidia
  nvf=
  ls -l /dev/nvidia*
  if [ $? -eq 0 ]; then
    nvf=--nv
  fi
  # only test for apptainer functionality if apptainer is present
  # may not be in all pods

  /usr/bin/apptainer exec $nvf --contain --ipc --pid --bind /cvmfs /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-el7:latest /usr/bin/dc -e "3 5 + p"
  rc=$?

  if [ $rc -ne 0 ]; then
    echo "Apptainer test execution failed!"
    exit 1
  fi

  # this is the real test, as used by HTCondor
  su htcuser -c '/usr/bin/apptainer exec $nvf --contain --ipc --pid --bind /cvmfs /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-el7:latest /usr/bin/dc -e "3 5 + p"'
  rc=$?

  if [ $rc -ne 0 ]; then
    echo "Unprivileged apptainer test execution failed!"
    exit 1
  fi

fi
