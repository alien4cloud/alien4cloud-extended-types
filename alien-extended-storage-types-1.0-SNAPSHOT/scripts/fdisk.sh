#!/bin/bash -e

use_external_resource=$(ctx source node properties use_external_resource)
partition_type=$(ctx source node properties partition_type)
partition_number=1
device_name=$(ctx target instance runtime_properties device_name)

if [ -z "$device_name" ]; then
	device_name=$(ctx target node properties device_name)
fi

if [ -z "${use_external_resource}" ]; then

    ctx logger info "Creating disk partition on device ${device_name}"
    (echo n; echo p; echo ${partition_number}; echo ; echo ; echo t; echo ${partition_type}; echo w) | sudo fdisk ${device_name}

else
    ctx logger info "Not partitioning device since 'use_external_resource' is set to true"
fi

# Set this runtime property on the source (the filesystem)
# its needed by subsequent scripts
ctx source instance runtime-properties filesys ${device_name}${partition_number}
