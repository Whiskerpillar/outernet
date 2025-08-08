#! /bin/bash

echo Provision Raspbian System for outernet 1.02

    # Check if the script is being run with sudo
if [ -z "$SUDO_USER" ]; then
    echo "This script must be run with sudo."
    exit 1
fi

    # Get the original user's home directory
ORIGINAL_USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

echo Thank you for Installing Outernet | read -t 5 | echo lets keep moving...

read -p "What is your Node's name? :" setNODE_NAME
setNODE_NAME=${setNODE_NAME:-"Wanderer"}
read -p "What is your network SSID (default: murmur)? :" setNETWORKSSID
setNETWORKSSID=${setNETWORKSSID:-"murmur"}
read -p "Would you like to use a static IP Address? ('false' disables / IP address enables) (default: false) :" setIPADDRESS
setIPADDRESS=${setIPADDRESS:-"false"}
read -p "Would you like to install to update and download apps? (y/n) (default: n) :" installDOWNLOAD_APPS
installDOWNLOAD_APPS=${installDOWNLOAD_APPS:-"n"}
echo Installing files to system folders...


    #Creating and Cleaning old directories
sudo rm /etc/outernet -r
mkdir -p /etc/outernet

sudo rm /var/log/outernet
mkdir -p /var/log/outernet

    #Moving Service from home to usr
if mv -f $ORIGINAL_USER_HOME/outernet/install/service/outernet-service.sh /usr/local/bin/; then
  echo "outernet-service.sh: success."
else
  echo "Error: outernet-service.sh could not be moved."
  exit 1
fi

    #moving Services
if mv -f $ORIGINAL_USER_HOME/outernet/install/service/services/* /etc/systemd/system/; then
  echo "Service: success."
else
  echo "Error: Outerent services could not be moved."
  exit 1
fi

    #moving Log files
if mv -f $ORIGINAL_USER_HOME/outernet/install/logs/* /var/log/outernet/; then
  echo "Logs: success."
  LOG_FILE="/var/log/outernet.log"
else
  echo "Error: log files could not be moved."
  exit 1
fi

    #moving service config into etc
if mv -f $ORIGINAL_USER_HOME/outernet/install/service/config/* /etc/outernet/; then
  echo "Config: success."
else
  echo "Error: outernet config files could not be moved."
  exit 1
fi

echo Files moved Successfully!

    #Setting as exacuatable 
sudo chmod +x /usr/local/bin/outernet-service.sh


    #Sets location of the Config file
CONFIG_FILE="/etc/outernet/outernet.conf"


    #Sends current config to the log
sudo sed "s/NODE_NAME=.*/NODE_NAME="$setNODE_NAME"/" $CONFIG_FILE | sudo tee /var/outernet.conf > /dev/null

echo Setting configuration files
sudo sed -i "s/^NODE_NAME=.*/NODE_NAME=\"$setNODE_NAME\"/" $CONFIG_FILE
sudo sed -i "s/^WIRELESS_ESSID=.*/WIRELESS_ESSID=\"$setNETWORKSSID\"/" $CONFIG_FILE
sudo sed -i "s/STATIC_ADDRESS=.*/STATIC_ADDRESS=\"$setIPADDRESS\"/" $CONFIG_FILE

    #Enabling services. 
echo Enabling Outernet service
sudo systemctl enable outernet


    #Downloads requried Apps. 
if [[ "$installDOWNLOAD_APPS" == "y" ]]; then
    sudo apt update
    sudo apt install gpsd
    sudo apt install mumble
    sudo apt install mumble-server
fi

echo config Set Successfully!
