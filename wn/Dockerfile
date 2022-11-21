FROM sfiligoi/prp-portal-wn

# needed by CVMFS checks
RUN yum -y install attr && yum clean all

# since we have CVMFS, use that singularity as it is updated more often
# embedded in the npid script
ADD scripts/singularity_npid.sh /usr/bin/singularity_npid.sh
ADD scripts/apptainer_npid.sh /usr/bin/apptainer_npid.sh
ADD scripts/monitor_cvmfs.sh /usr/sbin/monitor_cvmfs.sh
RUN chmod a+x /usr/sbin/monitor_cvmfs.sh

# Some additional CVMFS checks, also use a PRP-specific DNS name
ADD image-config.d/* /etc/constainer_startup/image-config.d/

# we will use passwd authentication
# and force mount /cvmfs
ADD condor.d/* /etc/condor/config.d/

#
# Env variables
# USE_SINGULARITY=no|native|npid
# GLIDEIN_Site
# ACCEPT_JOBS_FOR_HOURS
# CVMFS_REPOS
#
# Reminder: Accepts also env variables
# CONDOR_HOST STARTD_NOCLAIM_SHUTDOWN
# NUM_CPUS MEMORY DISK NUM_GPUS
# PHYSICAL_HOSTNAME
# K8S_NAMESPACE K8S_DOMAIN
# NVIDIA_SYMLINK
#

