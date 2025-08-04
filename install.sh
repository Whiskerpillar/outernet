#! /bin/bash

echo Provision Raspbian System for outernet 1.00 

# Check if the script is being run with sudo
if [ -z "$SUDO_USER" ]; then
    echo "This script must be run with sudo."
    exit 1
fi

# Get the original user's home directory
ORIGINAL_USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

read -p "What is your Node's name? :" setNODE_NAME
read -p "What is your network SSID (default: murmur)? :" setNETWORKSSID
read -p "Would you like to use a static IP Address? ('false' disables / IP address enables) :" setIPADDRESS
read -p "Would you like to install to update and download apps? (y/n) :" installDOWNLOAD_APPS
echo Installing files to system folders...

#Moving Service from home to usr
if mv -f $ORIGINAL_USER_HOME/outernet/install/service/outernet-service.sh /usr/local/bin/; then
  echo "outernet-service.sh: success."
else
  echo "Error: outernet-service.sh could not be moved."
  exit 1
fi

#Setting as exacuatable 
sudo chmod +x /usr/local/bin/outernet-service.sh

#moving into Systemd
if mv -f $ORIGINAL_USER_HOME/outernet/install/service/outernet.service /etc/systemd/system/; then
  echo "outernet.service: success."
else
  echo "Error: outernet.service could not be moved."
  exit 1
fi

#moving into etc
if mv -f $ORIGINAL_USER_HOME/outernet/install/outernet.conf /etc/; then
  echo "outernet.conf: success."
else
  echo "Error: outernet.conf could not be moved."
  exit 1
fi

#moving into var/log
if mv -f $ORIGINAL_USER_HOME/outernet/install/outernet.log /var/log/; then
  echo "outernet.log: success."
  LOG_FILE="/var/log/outernet.log"
else
  echo "Error: outernet.log could not be moved."
  exit 1
fi

echo Files moved Successfully!


#Sends current config to the log
sudo sed "s/NODE_NAME=.*/NODE_NAME="$setNODE_NAME"/" /etc/outernet.conf | sudo tee /var/outernet.conf > /dev/null

echo Setting configuration files
sudo sed -i "s/NODE_NAME=.*/NODE_NAME="$setNODE_NAME"/" /etc/outernet.conf
sudo sed -i "s/WIRELESS_ESSID=.*/WIRELESS_ESSID="$setNETWORKSSID"/" /etc/outernet.conf
sudo sed -i "s/STATIC_ADDRESS=.*/STATIC_ADDRESS="$setIPADDRESS"/" /etc/outernet.conf


echo config Set Successfully!

if [["$installDOWNLOAD_APPS" == "y"]]; then
    sudo apt update
    sudo apt install gpsd
    sudo apt install mumble
    sudo apt install mumble-server
fi
