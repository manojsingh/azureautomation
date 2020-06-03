#!/bin/bash

#install powershell
cd /tmp
sudo wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo apt-get install ./packages-microsoft-prod.deb
sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install powershell

# download application
sudo wget https://raw.github.com/Microsoft/dotnet-core-sample-templates/master/dotnet-core-music-linux/music-app/music-store-azure-demo-pub.tar /
sudo mkdir /opt/demoapp
sudo tar -xf demo-app.tar -C /opt/demoapp


# install nodejs
sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893
sudo apt-get update
sudo apt-get install -y dotnet-dev-1.0.0-preview2-003121

# install nginx, update config file
sudo apt-get install -y nginx
sudo service nginx start
sudo touch /etc/nginx/sites-available/default
sudo wget https://raw.githubusercontent.com/manojsingh/azureautomation/master/demoapp/nginx-config/default -O /etc/nginx/sites-available/default
sudo cp /opt/demoapp/nginx-config/default /etc/nginx/sites-available/
sudo nginx -s reload



# Populate DB for Demo
/opt/demoapp/populatedb.sh &