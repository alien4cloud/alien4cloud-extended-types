#!/bin/bash -e

# use_external_resource=$(ctx source node properties use_external_resource)
partition_number=1
partition_type=${PARTITION_TYPE}
device_name=${DEVICE}

if [ -z "${use_external_resource}" ]; then
    echo "Creating disk partition on device ${device_name}"
    (echo n; echo p; echo ${partition_number}; echo ; echo ; echo t; echo ${partition_type}; echo w) | sudo fdisk ${device_name}
else
    echo "Not partitioning device since 'use_external_resource' is set to true"
fi

# Set this runtime property on the source (the filesystem)
# its needed by subsequent scripts
# ctx source instance runtime-properties filesys ${device_name}${partition_number}
export PARTITION_NAME=${device_name}${partition_number}
