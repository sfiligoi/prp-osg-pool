#!/bin/bash

chown condor:condor /var/lib/condor/execute
chmod o-w /var/lib/condor/execute

chown condor:condor /var/lib/condor/spool
chmod o-w /var/lib/condor/spool

