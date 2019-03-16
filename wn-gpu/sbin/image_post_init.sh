#!/bin/bash


# Users expect a working OpenCL setup, so fail if it is not there
source /usr/local/sbin/validate_opencl.sh

# Condor needs the proper users in place
source /usr/local/sbin/add_image_users.sh
