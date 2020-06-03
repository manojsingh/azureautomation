#!/bin/bash

#install powershell
cd /tmp
sudo wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo apt-get install ./packages-microsoft-prod.deb
sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install powershell

# download application
sudo wget https://raw.githubusercontent.com/manojsingh/azureautomation/master/demoapp/demoapp.tar /
sudo mkdir /opt/demoapp
sudo tar -xf demoapp.tar -C /opt/demoapp


# install nodejs
sudo apt update
sudo apt install -y nodejs
sudo apt install -y npm 

#run node application


# install nginx, update config file
sudo apt-get install -y nginx
sudo service nginx start
sudo touch /etc/nginx/sites-available/default
sudo wget https://raw.githubusercontent.com/manojsingh/azureautomation/master/demoapp/nginx-config/default -O /etc/nginx/sites-available/default
sudo cp /opt/demoapp/nginx-config/default /etc/nginx/sites-available/
sudo nginx -s reload



# Populate DB for Demo
/opt/demoapp/populatedb.sh &