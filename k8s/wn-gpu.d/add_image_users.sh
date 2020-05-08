#!/bin/bash

# List of all supported users
groupadd -g 3001 osg && useradd -u 3001 -g 3001 -s /bin/bash osg
groupadd -g 3002 icecube && useradd -u 3002 -g 3002 -s /bin/bash icecube
groupadd -g 3003 glow && useradd -u 3003 -g 3003 -s /bin/bash glow
groupadd -g 3004 ligo && useradd -u 3004 -g 3004 -s /bin/bash ligo
groupadd -g 3005 xenon.biggrid.nl && useradd -u 3005 -g 3005 -s /bin/bash xenon.biggrid.nl
groupadd -g 3006 fermigli && useradd -u 3006 -g 3006 -s /bin/bash fermigli

