#
# prp-osg-pool/provisioner
#
# BSD license, copyright Igor Sfiligoi 2021
#
# Main entry point of the provisioner process
#

import sys
import time

from . import provisioner_k8s as provisioner_k8s

import prp_provisioner.provisioner_logging as provisioner_logging
import prp_provisioner.provisioner_htcondor as provisioner_htcondor
import prp_provisioner.event_loop as event_loop

def main(log_fname, namespace, cvmfs_mounts, max_pods_per_cluster=20, sleep_time=60):
   log_obj = provisioner_logging.ProvisionerFileLogging(log_fname, want_log_debug=True)
   # TBD: Proper security
   schedd_obj = provisioner_htcondor.ProvisionerSchedd(namespace, {'.*':'.*'})
   collector_obj = provisioner_htcondor.ProvisionerCollector(namespace, '.*')
   k8s_obj = provisioner_k8s.OSGProvisionerK8S(namespace, cvmfs_mounts)
   k8s_obj.authenticate()

   el = event_loop.ProvisionerEventLoop(log_obj, schedd_obj, collector_obj, k8s_obj, max_pods_per_cluster)
   while True:
      log_obj.log_debug("[Main] Iteration started")
      try:
         el.one_iteration()
      except:
         log_obj.log_debug("[Main] Exception in one_iteration")
      log_obj.sync()
      time.sleep(sleep_time)

if __name__ == "__main__":
   # execute only if run as a script
   main(sys.argv[1], sys.argv[2], sys.argv[3].split(","))

