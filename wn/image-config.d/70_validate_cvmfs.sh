#!/bin/bash

if [ "x${CVMFS_REPOS}" == "x" ]; then
  CVMFS_REPOS=`(cd /cvmfs && /usr/bin/ls -F -d * | awk 'BEGIN{l=""}/\//{split($0,a,"/"); if (l!="") l=l ","; l=l a[1]}END{print l}')`
  echo "INFO: `date` Auto-detected CVMFS mounts: ${CVMFS_REPOS}"
fi

for d in `echo ${CVMFS_REPOS} |tr , ' '` ; do
    if [ ! -d "/cvmfs/${d}" ]; then
      echo "ERROR: `date` Not mounted: /cvmfs/${d}. "
      exit 1
    fi
    if [ "`ls /cvmfs/${d} |wc -l`" -lt 2 ]; then
      echo "ERROR: `date` Empty dir: /cvmfs/${d}. "
      exit 1
    fi
done

# oasis should be always present
# pick a well defined file, e.g. singularity
ls -l /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity
rc=$?

if [ $rc -ne 0 ]; then
  echo "ERROR: `date` Oasis CVMFS not readable (/cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity)"
  exit 1
fi


echo "# configured CVMFS mounts" > /etc/condor/config.d/10_cvmfs.conf
for d in `echo ${CVMFS_REPOS} |tr , ' '` ; do
  v=`echo $d | sed 's/\./_/g' | sed 's/-/_/g'`
  echo "HAS_CVMFS_$v=True" >> /etc/condor/config.d/10_cvmfs.conf
  echo 'STARTD_EXPRS = $(STARTD_EXPRS)' HAS_CVMFS_$v >> /etc/condor/config.d/10_cvmfs.conf
done

# keep monitoring the CVMFS mounts indefinitely
/usr/sbin/monitor_cvmfs.sh "${CVMFS_REPOS}" </dev/null &
