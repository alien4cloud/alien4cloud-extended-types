#!/bin/bash -e

partition_number=1
device_name=${DEVICE}

echo "Checking existing partition for $device_name"
sudo fdisk -l $device_name 2>/dev/null | grep -E "$device_name[0-9]"
PARTITION_EXISTENCE=$(echo $?)
if [ $PARTITION_EXISTENCE -ne 0 ] ; then
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
