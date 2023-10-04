#!/bin/sh

if [ "$#" != "1" -o -z "$1" ]; then
    echo "Usage: $0 setup"
    echo "       $0 cleanup"
    exit 1
fi

if [ "$1" = "cleanup" ]; then
    ssh "root@${FA_CONTROLLER_IP}" bash << 'EOS'

# Delete local users
pureds local user delete rose
pureds local user delete steven
pureds local user delete zsvoboda

# Delete local groups
pureds local group delete sales
pureds local group delete product
pureds local group delete zsvoboda

# Detach and remove the autodir policy 
echo "Removing autodir policy"
purepolicy autodir remove --dir fs_shared:md_home_dir p_home_dir_autodir
purepolicy autodir delete p_home_dir_autodir

# Detach and remove the NFS export policy 
echo "Removing NFS export policy"
purepolicy nfs remove --dir fs_shared:md_home_dir p_home_dir_nfs
purepolicy nfs delete p_home_dir_nfs

# Detach and remove the SMB share policy
echo "Removing SMB share policy"
purepolicy smb remove --dir fs_shared:md_home_dir p_home_dir_smb
purepolicy smb delete p_home_dir_smb

# Delete the managed directory
echo "Deleting managed directory"
puredir delete fs_shared:md_home_dir

# Delete and eradicate the filesystem
echo "Deleting and eradicating filesystem"
purefs destroy fs_shared
purefs eradicate fs_shared

EOS
    exit $?
fi

if [ "$1" = "setup" ]; then

ssh "root@${FA_CONTROLLER_IP}" bash << 'EOS'

set -eu
set -o pipefail

# backup original stdout to fd3 and redirect stdout to stderr
exec 3>&1
exec 1>&2

# Local groups
pureds local group create --gid 28100 sales
pureds local group create --gid 28200 product
pureds local group create --gid 20 zsvoboda

# Local users
{ echo 'password'; echo 'password'; } | pureds local user create --password --uid 28110 --primary-group sales rose
{ echo 'password'; echo 'password'; } | pureds local user create --password --uid 28210 --primary-group product steven
{ echo 'password'; echo 'password'; } | pureds local user create --password --uid 502 --primary-group zsvoboda zsvoboda

# Autodir policy (for home directories)
echo "Creating autodir policy"
purepolicy autodir create p_home_dir_autodir

# Filesystem
echo "Creating filesystem"
purefs create fs_shared

# Managed directory
echo "Creating managed directory"
puredir create --path /home fs_shared:md_home_dir
echo "Attaching the autodir policy to the managed directory"
purepolicy autodir add --dir fs_shared:md_home_dir p_home_dir_autodir

# NFS export policy
echo "Creating NFS export policy"
purepolicy nfs create p_home_dir_nfs
purepolicy nfs rule add --client "*" --no-root-squash --anonuid 65534 --anongid 65534 --version nfsv4 p_home_dir_nfs

# NFS export
echo "Creating NFS export"
purepolicy nfs add --dir fs_shared:md_home_dir --export-name HOME p_home_dir_nfs

# SMB share policy
echo "Creating SMB share policy"
purepolicy smb create p_home_dir_smb
purepolicy smb rule add --client "*" p_home_dir_smb

# SMB share
echo "Creating SMB share"
purepolicy smb add --dir fs_shared:md_home_dir --export-name HOME p_home_dir_smb

# restore stdout from fd3
exec 1>&3
EOS

exit $?
fi