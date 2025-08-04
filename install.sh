#! /bin/bash

echo Provision Raspbian System for outernet 1.00 

# Check if the script is being run with sudo
if [ -z "$SUDO_USER" ]; then
    echo "This script must be run with sudo."
    exit 1
fi

# Get the original user's home directory
ORIGINAL_USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

echo Installing files to system folders...

#Moving Service from home to usr
if mv -f $ORIGINAL_USER_HOME/outernet/install/service/outernet-service.sh /usr/local/bin/; then
  echo "File moved successfully."
else
  echo "Error: outernet-service.sh could not be moved."
  exit 1
fi

#Setting as exacuatable 
sudo chmod +x /usr/local/bin/outernet-service.sh

#moving into Systemd
if mv -f $ORIGINAL_USER_HOME/outernet/install/service/outernet.service /etc/systemd/system/; then
  echo "File moved successfully."
else
  echo "Error: outernet.service could not be moved."
  exit 1
fi

#moving into etc
if mv -f $ORIGINAL_USER_HOME/outernet/install/outernet.conf /etc/; then
  echo "File moved successfully."
else
  echo "Error: outernet.conf could not be moved."
  exit 1
fi

#moving into var/log
if mv -f $ORIGINAL_USER_HOME/outernet/install/outernet.log /var/log/; then
  echo "File moved successfully."
else
  echo "Error: outernet.conf could not be moved."
  exit 1
fi
echo File move Complete!

LOG_FILE="/var/log/outernet.log"


read -p "What is your Node's name? :" setNODE_NAME
sudo sed "s/NODE_NAME=.*/NODE_NAME="$setNODE_NAME"/" /etc/outernet.conf | sudo tee /var/outernet.conf
sudo sed -i "s/NODE_NAME=.*/NODE_NAME="$setNODE_NAME"/" /etc/outernet.conf

read -p "What is your network SSID ? :" setNETWORKSSID
sudo sed -i "s/WIRELESS_ESSID=.*/WIRELESS_ESSID="$setNETWORKSSID"/" /etc/outernet.conf


