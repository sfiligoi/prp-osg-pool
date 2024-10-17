FROM rockylinux:9

# dependency needed by OSG
RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled crb && \
    yum clean all

# OSG RPMs
RUN yum -y install https://repo.opensciencegrid.org/osg/23-main/osg-23-main-el9-release-latest.rpm && \
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    yum -y install python3-pip git less which && \
    yum -y install osg-ca-certs condor python3-condor && \
    yum clean all


RUN pip3 install kubernetes


# Tell condor to use osg-ca-certs
ADD 03_condor_sec.config /etc/condor/config.d/03_condor_sec.config

# configure python packages
RUN mkdir -p /opt/provisioner && cd /opt/provisioner && git clone https://github.com/sfiligoi/prp-htcondor-portal.git && cd prp-htcondor-portal && git checkout osg_pool_base

RUN useradd provisioner && chown -R provisioner /opt/provisioner

RUN su provisioner -c '/usr/bin/ln -s /opt/provisioner/prp-htcondor-portal/provisioner/python/prp_provisioner /home/provisioner/prp_provisioner'

ADD provisioner_main.py /home/provisioner/provisioner_main.py
ADD provisioner_info.py /home/provisioner/provisioner_info.py
RUN chown provisioner /home/provisioner/provisioner_main.py; chmod a+x /home/provisioner/provisioner_info.py; chown provisioner /home/provisioner/provisioner_info.py

ADD setup_k8s_creds.sh /opt/provisioner/setup_k8s_creds.sh
ADD setup_htcondor_creds.sh /opt/provisioner/setup_htcondor_creds.sh
ADD provisioner_startup.sh /opt/provisioner/provisioner_startup.sh

#
# Requires env variables
# CONDOR_HOST
# K8S_NAMESPACE
# CVMFS_MOUNTS

#
# Optional env variable
# HTCONDOR_QUERY_INSECURE
#

CMD ["/opt/provisioner/provisioner_startup.sh"]

