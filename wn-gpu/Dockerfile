FROM nvidia/cuda:10.0-runtime-centos7

# Needed to get the recently deprecated libcudart.so symlink in place
RUN yum -y install cuda-cudart-dev-10-0-10.0.130-1.x86_64

# OSG RPMs
RUN yum -y install https://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install  \
                   osg-wn-client \
                   redhat-lsb-core && \
    yum -y install condor && \
    yum -y install supervisor

# Enable OpenCL
# As suggested by https://github.com/WIPACrepo/pyglidein/blob/master/Dockerfile
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# Some helper OpenCL tools
RUN yum install -y clinfo

# Suggested RPMs from https://hub.docker.com/r/opensciencegrid/osgvo-el7/dockerfile
RUN yum -y groupinstall "Compatibility Libraries" \
                        "Development Tools" \
                        "Scientific Support"


RUN yum clean all

# Condor does not pick up the system libraries
ADD cudalib.sh /etc/profile.d/

ADD 01_resource_limits.config /etc/condor/config.d/01_resource_limits.config
ADD 97_procd_workaround.config /etc/condor/config.d/97_procd_workaround.config
ADD 98_security.config /etc/condor/config.d/98_security.config
ADD 99_daemons.config /etc/condor/config.d/99_daemons.config


ADD sbin/* /usr/local/sbin/

ADD supervisord.conf /etc/
RUN mkdir -p /var/log/supervisor

CMD ["/usr/local/sbin/supervisord_startup.sh"]

