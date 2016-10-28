#!/bin/bash -e

partition_number=1
partition_type=${PARTITION_TYPE}
device_name=${DEVICE}

echo "Checking existing partition for $device_name"
sudo fdisk -l $device_name 2>/dev/null | grep -E "$device_name[0-9]"
PARTITION_EXISTANCE=$(echo $?)
if [ $PARTITION_EXISTANCE -ne 0 ] ; then
    echo "Creating disk partition on device ${device_name}"
    (echo n; echo p; echo ${partition_number}; echo ; echo ; echo t; echo ${partition_type}; echo w) | sudo fdisk ${device_name}
else
    echo "Not partitioning device since a partition already exist"
fi

# Set this runtime property on the source (the filesystem)
# its needed by subsequent scripts
# ctx source instance runtime-properties filesys ${device_name}${partition_number}
export PARTITION_NAME=${device_name}${partition_number}
