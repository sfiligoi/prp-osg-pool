FROM centos:centos7

# OSG RPMs
RUN yum -y install https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install less which \
                   redhat-lsb-core && \
    yum -y install python3-pip git && \
    yum -y install condor python3-condor && \
    yum clean all


RUN pip3 install kubernetes


# add condor config
ADD 98_security.config /etc/condor/config.d/98_security.config


# configure python packages
RUN mkdir -p /opt/provisioner && cd /opt/provisioner && git clone https://github.com/sfiligoi/prp-htcondor-portal.git && cd prp-htcondor-portal && git checkout main
RUN mkdir -p /opt/provisioner && cd /opt/provisioner && git clone https://github.com/sfiligoi/prp-osg-pool.git && cd prp-osg-pool && git checkout provisioner_2109

RUN useradd provisioner && chown -R provisioner /opt/provisioner

RUN su provisioner -c '/usr/bin/ln -s /opt/provisioner/prp-osg-pool/provisioner/python/osg_provisioner /home/provisioner/osg_provisioner'
RUN su provisioner -c '/usr/bin/ln -s /opt/provisioner/prp-htcondor-portal/provisioner/python/prp_provisioner /home/provisioner/prp_provisioner'

ADD setup_k8s_creds.sh /opt/provisioner/setup_k8s_creds.sh

