FROM sfiligoi/prp-portal-wn

# needed by CVMFS checks
RUN yum -y install attr && yum clean all

# glideins will try to use the default singularity, so must create the symlink
RUN ln -s  /usr/bin/singularity_npid.sh /usr/bin/singularity

# Some additional CVMFS checks, also use a PRP-specific DNS name
ADD image-config.d/* /etc/constainer_startup/image-config.d/

# we will use passwd authentication
ADD 98_security.config /etc/condor/config.d/

#
# Reminder: Accepts env variables
# CONDOR_HOST STARTD_NOCLAIM_SHUTDOWN
# NUM_CPUS MEMORY DISK NUM_GPUS
# K8S_NAMESPACE
#

