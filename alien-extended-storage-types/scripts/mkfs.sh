#!/bin/bash -e

fs_type=${FS_TYPE}
filesys=${PARTITION_NAME}

EXISTING_FS_TYPE=$(sudo lsblk -no FSTYPE $PARTITION_NAME)
if [ -z $EXISTING_FS_TYPE ] ; then
    mkfs_executable=''
    case ${fs_type} in
        ext2 | ext3 | ext4 | fat | ntfs )
         mkfs_executable='mkfs.'${fs_type};;
        swap )
         mkfs_executable='mkswap';;
        * )
         echo "File system type is not supported."
         exit 1;;
    esac

    echo "Creating ${fs_type} file system using ${mkfs_executable}"
    sudo ${mkfs_executable} ${filesys}
else
    if [ "$EXISTING_FS_TYPE" != "$fs_type" ] ; then
        echo "Existing filesystem ($EXISTING_FS_TYPE) but not the expected type ($fs_type)"
        exit 1
    fi
    echo "Not making a filesystem since a it already exist"
fi
