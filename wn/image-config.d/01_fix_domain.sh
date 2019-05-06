#!/bin/bash

# k8s nodes have no domain, which is annoying
# Add it here
cp /etc/hosts /tmp/hosts && sed 's/\(osg-wn-.*\)/\1\.optiputer.net \1/' /tmp/hosts > /etc/hosts && rm -f /tmp/hosts
