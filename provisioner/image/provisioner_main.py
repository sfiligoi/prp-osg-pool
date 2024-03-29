#
# prp-osg-pool/provisioner
#
# BSD license, copyright Igor Sfiligoi 2022
#
# Main entry point of the provisioner process
#

import sys
import time
import configparser

import prp_provisioner.provisioner_k8s as provisioner_k8s
import prp_provisioner.provisioner_logging as provisioner_logging
import prp_provisioner.provisioner_htcondor as provisioner_htcondor
import prp_provisioner.event_loop as event_loop

def main(log_fname, namespace, cvmfs_mounts, max_pods_per_cluster=20, sleep_time=60):
   fconfig = configparser.ConfigParser()
   fconfig.read(('pod.conf','osg_provisioner.conf'))
   kconfig = provisioner_k8s.ProvisionerK8SConfig(namespace)
   cconfig = provisioner_htcondor.ProvisionerHTCConfig(namespace)

   # we will distinguish this class by these attrs
   kconfig.additional_labels['osg-provisioner'] = 'wn'
   kconfig.app_name = 'osg-wn'
   cconfig.app_name = 'osg-wn'

   if 'k8s' in fconfig:
      kconfig.parse(fconfig['k8s'])
   else:
      kconfig.parse(fconfig['DEFAULT'])

   if 'htcondor' in fconfig:
      cconfig.parse(fconfig['htcondor'])
   else:
      cconfig.parse(fconfig['DEFAULT'])

   cvmfsenvs=[]

   # we always need the osg-config and oasis
   for c in (['config-osg','oasis'] + cvmfs_mounts):
      ext='opensciencegrid.org' if c!='stash' else 'osgstorage.org'
      kconfig.base_pvc_volumes["cvmfs-%s"%c] =  "/cvmfs/%s.%s"%(c,ext)
      cvmfsenvs.append( "%s.%s"%(c,ext) )

   kconfig.additional_envs['CVMFS_REPOS'] = ",".join(cvmfsenvs)

   log_obj = provisioner_logging.ProvisionerFileLogging(log_fname, want_log_debug=True)
   # TBD: Strong security
   schedd_whitelist=fconfig['htcondor'].get('schedd_whitelist_regexp','.*')
   schedd_obj = provisioner_htcondor.ProvisionerSchedd(log_obj, {schedd_whitelist:'.*'}, cconfig)
   collector_obj = provisioner_htcondor.ProvisionerCollector(log_obj, '.*', cconfig)
   k8s_obj = provisioner_k8s.ProvisionerK8S(kconfig)
   k8s_obj.authenticate()

   el = event_loop.ProvisionerEventLoop(log_obj, schedd_obj, collector_obj, k8s_obj, max_pods_per_cluster)
   while True:
      log_obj.log_debug("[Main] Iteration started, schedd whitelist='%s'"%schedd_whitelist)
      try:
         el.one_iteration()
      except:
         log_obj.log_debug("[Main] Exception in one_iteration")
      log_obj.sync()
      time.sleep(sleep_time)

if __name__ == "__main__":
   # execute only if run as a script
   main(sys.argv[1], sys.argv[2], sys.argv[3].split(","))

