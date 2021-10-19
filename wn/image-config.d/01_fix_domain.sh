#!/bin/bash

if [ 'x${K8S_NAMESPACE}' == 'x' ]; then
  K8S_NAMESPACE='prp'
fi

# k8s nodes have no domain, which is annoying
# Add it here
cp /etc/hosts /tmp/hosts && sed "s/\(osg-wn-.*\)/\1\.${K8S_NAMESPACE}.optiputer.net \1/" /tmp/hosts > /etc/hosts && rm -f /tmp/hosts
