#
# prp-osg-pool/provisioner
#
# BSD license, copyright Igor Sfiligoi 2021
#
# Implement the Kubernetes interface
#

import copy
import re
import kubernetes
import time

from prp_provisioner.provisioner_k8s import ProvisionerK8S


class OSGProvisionerK8S(ProvisionerK8S):
   """Kubernetes Query interface"""

   def __init__(self, config):
      ProvisionerK8S.__init__(self, config)

   # INTERNAL

   def _augment_volumes(self, volumes, attrs):
      """Add any additional (volume,mount) pair to the dictionary (attrs is read-only)"""

      ProvisionerK8S._augment_volumes(self, volumes, attrs)

      # mount the shared secret
      # instead of the token
      volumes['configpasswd'] = \
                   (
                      {
                         'secret': {
                            'secretName': 'osg-pool-sdsc-config',
                            'defaultMode': 256,
                            'items': [{
                               'key': 'pool_password',
                               'path': 'pool_password'
                            }]
                         }
                      },
                      {
                         'mountPath': '/etc/condor/secret/pool_password',
                         'subPath': 'pool_password',
                         'readOnly': True
                      }
                   )

      return


