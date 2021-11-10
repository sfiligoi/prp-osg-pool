#
# provisioner startup python script
#
# BSD license, copyright Igor Sfiligoi@UCSD 2021
#
# Requires two arguments:
#   Namespce
#   CVMFS_Moounts (comma separated list)
#

import sys
import osg_provisioner.provisioner

osg_provisioner.provisioner.main(sys.argv[1], sys.argv[2], sys.argv[3].split(","))
