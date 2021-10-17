FROM nvidia/cuda:11.3.0-runtime-centos7

RUN yum update -y && yum clean all

# OSG RPMs
RUN yum -y install https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install  \
                   osg-wn-client \
                   redhat-lsb-core && \
    yum -y install condor && \
    yum -y install supervisor && \
    yum clean all

# libseccom needed by some versions of singularity
RUN yum -y install libseccomp && yum clean all

# needed by CVMFS checks
RUN yum -y install attr && yum clean all

# Enable OpenCL
# As suggested by https://github.com/WIPACrepo/pyglidein/blob/master/Dockerfile
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# Some helper OpenCL tools
RUN yum install -y clinfo && yum clean all

# Condor does not pick up the system libraries
ADD wn-gpu/cudalib.sh /etc/profile.d/

# Root-less singularity
# Needs /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity
ADD singularity_npid.sh /usr/bin/singularity

ADD wn-gpu/01_resource_limits.config /etc/condor/config.d/
ADD 97_procd_workaround.config /etc/condor/config.d/
ADD 98_security.config /etc/condor/config.d/
ADD 99_daemons.config /etc/condor/config.d/
ADD wn-gpu/02_gpu_jobs.config /etc/condor/config.d/

ADD sbin/* /usr/local/sbin/

ADD supervisord.conf /etc/
RUN mkdir -p /var/log/supervisor

RUN mkdir -p /etc/supervisord_startup/image-config.d
ADD image-config.d/* /etc/supervisord_startup/image-config.d/
ADD wn-gpu/image-config.d/* /etc/supervisord_startup/image-config.d/


CMD ["/usr/local/sbin/supervisord_startup.sh"]

