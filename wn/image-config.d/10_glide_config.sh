#!/bin/bash

if [ "x${GLIDEIN_Site}" == "x" ]; then
  GLIDEIN_Site=prp
fi

if [ "x${ACCEPT_JOBS_FOR_HOURS}" == "x" ]; then
  ACCEPT_JOBS_FOR_HOURS=20
fi


echo "# Dynamic glidein config" > /etc/condor/config.d/10_glide.conf
echo "GLIDEIN_Site=\"${GLIDEIN_Site}\"" >> /etc/condor/config.d/10_glide.conf
echo "ACCEPT_JOBS_FOR_HOURS=${ACCEPT_JOBS_FOR_HOURS}" >> /etc/condor/config.d/10_glide.conf
echo 'STARTD_EXPRS = $(STARTD_EXPRS) GLIDEIN_Site ACCEPT_JOBS_FOR_HOURS' >> /etc/condor/config.d/10_glide.conf 

