#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# install nginx
sudo apt-get install nginx -y

# install git
sudo apt-get install git -y

# install nodejs
sudo apt-get install -y python-software-properties
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y

# install pm2
sudo npm install -y pm2 -g

# remove the default folders
sudo rm -rf /etc/nginx/sites-enabled
sudo rm -rf /etc/nginx/sites-available

# set up nginx reverse proxy
sudo ln -s /home/ubuntu/environment/app/nodeapp.conf /etc/nginx/conf.d/nodeapp.conf
sudo nginx -s reload
