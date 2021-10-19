#!/bin/bash

# basic setup
/opt/provisioner/setup_k8s_creds.sh

if [ "x${K8S_NAMESPACE}" == "x" ]; then
  echo "Missing K8S_NAMESPACE"
  sleep 15
  exit 1
fi

if [ "x${CVMFS_MOUNTS}" == "x" ]; then
  echo "Missing CVMFS_MOUNTS"
  sleep 15
  exit 1
fi

trap 'echo signal received!; kill $(jobs -p); wait' SIGINT SIGTERM

echo "`date` Starting provisioner_main.py"
su provisioner -c "cd /home/provisioner && python3 provisioner_main.py ${K8S_NAMESPACE} ${CVMFS_MOUNTS}" &
wait
rc=$?
echo "`date` End of provisioner_main.py, rc=${rc}"

