#!/bin/bash


sudo umount /mnt/home
sudo mkdir -p /mnt/home
sudo chmod 777 /mnt/home

# Mount the /mnt/HOME directory
clear 
printf "\n\n"

read -p "Press any key to mount the HOME directory over NFS 4.1 ..."

printf "\n\n"
echo sudo mount -t nfs -o vers=4.1 ${FA_MOUNT_IP}:/HOME /mnt/home/    
sudo mount -t nfs -o vers=4.1 ${FA_MOUNT_IP}:/HOME /mnt/home/

# Removing the /mnt/home/* directories if they exist
sudo rm -rf /mnt/home/rose
sudo rm -rf /mnt/home/steven

# Creating home directories, changing ownership and permissions (750)
printf "\n\n"

read -p "Press any key to create home directories ..."

printf "\n\n"

echo sudo mkdir /mnt/home/rose
sudo mkdir /mnt/home/rose
echo sudo chown rose:sales /mnt/home/rose
sudo chown rose:sales /mnt/home/rose
echo sudo chmod 750 /mnt/home/rose
sudo chmod 750 /mnt/home/rose

printf "\n\n"

echo sudo mkdir /mnt/home/steven
sudo mkdir /mnt/home/steven
echo sudo chown steven:product /mnt/home/steven
sudo chown steven:product /mnt/home/steven
echo sudo chmod 750 /mnt/home/steven
sudo chmod 750 /mnt/home/steven

# Creating the my_file.txt demo files in each home directory

printf "\n\n"
read -p "Press any key to create some demo files ..."

printf "\n\n"

echo sudo -u rose bash -c 'printf  "Woo hoo, I can read this file!" > /mnt/home/rose/my_file.txt'
sudo -u rose bash -c 'printf  "Woo hoo, I can read this file!" > /mnt/home/rose/my_file.txt'
sudo chown rose:sales /mnt/home/rose/my_file.txt
sudo chmod 750 /mnt/home/rose/my_file.txt

printf "\n\n"

echo sudo -u steven bash -c 'printf  "Woo hoo, I can read this file!" > /mnt/home/steven/my_file.txt'
sudo -u steven bash -c 'printf  "Woo hoo, I can read this file!" > /mnt/home/steven/my_file.txt'
sudo chown steven:product /mnt/home/steven/my_file.txt
sudo chmod 750 /mnt/home/steven/my_file.txt

# Testing whether Steven has access to his home directory

printf "\n\n"
read -p "Press any key to test Steven's access to his home directory ..."

printf "\n\n"

echo sudo -u steven ls -lah /mnt/home/steven
sudo -u steven ls -lah /mnt/home/steven

printf "\n\n"

# Testing whether Steven has access to Rose's home directory

printf "\n\n"
read -p "Press any key to test Steven's access to Rose's home directory ..."

printf "\n\n"

echo sudo -u steven ls -lah /mnt/home/rose
sudo -u steven ls -lah /mnt/home/rose

printf "\n\n"

# Now, we'll use the NFS4.1 ACLs to grant Steven access to Rose's home directory

read -p "Press any key to use the NFS4.1 ACLs to grant Steven access to Rose's home directory ..." 

printf "\n\n"

echo sudo bash -c 'nfs4_setfacl -a A::28210:RX /mnt/home/rose'
sudo bash -c 'nfs4_setfacl -a A::28210:RX /mnt/home/rose'

printf "\n\n"

read -p "Press any key to use the NFS4.1 ACLs to grant Steven access to Rose's my_file.txt file ..." 

printf "\n\n"

echo sudo bash -c 'nfs4_setfacl -a A::28210:RX /mnt/home/rose/my_file.txt'
sudo bash -c 'nfs4_setfacl -a A::28210:RX /mnt/home/rose/my_file.txt'

printf "\n\n"

read -p "Press any key to to display the rose's home directory ACL permissions ..." 

printf "\n\n"

echo sudo bash -c 'nfs4_getfacl /mnt/home/rose'
sudo bash -c 'nfs4_getfacl /mnt/home/rose'

printf "\n\n"

read -p "Press any key to to display the rose's demo file ACL permissions ..." 

printf "\n\n"

echo sudo bash -c 'nfs4_getfacl /mnt/home/rose/my_file.txt'
sudo bash -c 'nfs4_getfacl /mnt/home/rose/my_file.txt'

printf "\n\n"

read -p "Press any key to find out whether Steven can now list the rose's home directory?" 

printf "\n\n"

echo sudo -u steven bash -c 'ls -lah /mnt/home/rose/'
sudo -u steven bash -c 'ls -lah /mnt/home/rose/'

printf "\n\n"

read -p "Press any key to find out whether Steven can now read the rose's demo file?" 

printf "\n\n"

echo sudo -u steven bash -c 'cat /mnt/home/rose/my_file.txt'
sudo -u steven bash -c 'cat /mnt/home/rose/my_file.txt'

printf "\n\n"