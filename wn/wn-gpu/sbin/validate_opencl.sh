#!/bin/bash

cllist="`clinfo -l`"

if [ -z "$cllist" ]; then
  echo "No OpenCL devices found!"
  exit 1
fi
