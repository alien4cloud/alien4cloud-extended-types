#!/bin/bash -e

partition_number=1
device_name=${DEVICE}

echo "Checking existing partition for $device_name"
export LC_ALL=C
sudo parted --script $device_name print 2>/dev/null | grep "Partition Table: unknown"
PARTITION_UNKNOWN=$(echo $?)
if [ $PARTITION_UNKNOWN -eq 0 ] ; then
    echo "Creating disk partition gpt on device ${device_name}"
    sudo parted --script $device_name \
        mklabel gpt \
        mkpart primary 0% 100%
else
    echo "Not partitioning device since a partition already exist"
fi

# Set this runtime property on the source (the filesystem)
# its needed by subsequent scripts
# ctx source instance runtime-properties filesys ${device_name}${partition_number}
export PARTITION_NAME=${device_name}${partition_number}
