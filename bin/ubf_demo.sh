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

printf "\n\n"
read -p "Press any key to continue ..."
clear 
printf "\n\n"

# Removing the /mnt/home/* directories if they exist
sudo rm -rf /mnt/home/rose
sudo rm -rf /mnt/home/steven

# Creating home directories, changing ownership and permissions (750)
clear 
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

printf "\n\n"
read -p "Press any key to continue ..."
clear 
printf "\n\n"

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

printf "\n\n"
read -p "Press any key to continue ..."
clear 
printf "\n\n"
