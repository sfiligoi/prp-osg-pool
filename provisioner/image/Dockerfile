FROM centos:centos7

# OSG RPMs
RUN yum -y install https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install less which \
                   redhat-lsb-core && \
    yum -y install python3-pip git && \
    yum -y install condor && \
    yum clean all


RUN pip3 install kubernetes


RUN mkdir -p /opt/provisioner && cd /opt/provisioner && git clone https://github.com/sfiligoi/prp-htcondor-portal.git && cd prp-htcondor-portal && git checkout main
RUN mkdir -p /opt/provisioner && cd /opt/provisioner && git clone https://github.com/sfiligoi/prp-htcondor-pool.git && cd prp-htcondor-pool && git checkout provisioner_2109

RUN useradd provisioner && chown -R provisioner /opt/provisioner

ADD 98_security.config /etc/condor/config.d/98_security.config

