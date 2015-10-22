#!/bin/bash -e

fs_mount_path=${FS_MOUNT_PATH}

ctx logger info "Unmounting file system on ${fs_mount_path}"
sudo umount -l ${fs_mount_path}

ctx logger info "Removing ${fs_mount_path} directory"
sudo rmdir ${fs_mount_path}
