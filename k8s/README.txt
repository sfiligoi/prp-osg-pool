OSG HTCondor pool for PRP 

This directory contains the files to start the HTCondor pool on the PRP k8s cluster.

The order of instantiation is:

# Make sure the CVMFS CSI plugins are set up
# See prp-osg-cvmfs

# Create pool password file per HTCondor documentation
# Note: Do not check this file into git, as it is the base of the Condor security
cat > pool_password

# create the k8s secrets
make

# Start the collector pod
# The namespace is hardcoded to osg
kubectl create -f osg-collector.yaml

# Register the collector as a service
# (the namespace is already hardcoded as osg)
kubectl create -f service-osg-collector.yaml

# (optional) Propagate the service info into the target namespace
# Will assume osggpus namespace from here on
kubectl create -n osggpus -f service-osg-collector-gpus.yaml

# Start the worker nodes in the target namespace (assuming osggpus here)
kubectl create -n osggpus -f osg-wn-gpu.yaml 
