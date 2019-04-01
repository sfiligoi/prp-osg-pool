#!/bin/bash

# Users expect a working OpenCL setup, so fail if it is not there
cllist="`clinfo -l`"

if [ -z "$cllist" ]; then
  echo "No OpenCL devices found!"
  exit 1
fi
