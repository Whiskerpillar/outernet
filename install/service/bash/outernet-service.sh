#! /bin/bash

#outernet v1.03 network provision for Rasbian
#AM 8/2/2025

#Log to outernet.log
exec >> /var/log/outernet/outernet.log 2>&1

#CONFIG Defaults (Please do not change here as it will get overwriten by a the config file)
BOOT_TYPE="wifi"
STATIC_ADDRESS="false"
WIRELESS_CHANNEL="1"
WIRELESS_ESSID="outernet"
MESH_MTU="1468"
NODE_NAME="NewNode"

source /etc/outernet/outernet.conf

echo Config Values
echo $BOOT_TYPE $STATIC_ADDRESS $WIRELESS_CHANNEL $WIRELESS_ESSID $MESH_MTU

 
#FUNCTIONS - - - - -

function provisionMurmur {

echo Starting outernet v1.0 network provision for Rasbian
echo

echo Removing old Network Files...
sudo rm /etc/systemd/network/10-wlan0-mesh.network
sudo rm /etc/systemd/network/20-bat0.network
sudo rm /etc/systemd/network/20-bat0.netdev
echo

echo Updating Network Files
echo Eeeh Im a little lazy here. this will be updated to automatic but not yet

echo Copying new Network Files
sudo cp /etc/outernet/networkd/* /etc/systemd/network/

echo Stoping Networkd
sudo systemctl stop systemd-networkd
sudo systemctl stop NetworkManager

echo Stopping wpa services
sudo systemctl stop wpa_supplicant

echo Starting Outernet...

sudo systemctl daemon-reload
sudo systemctl start outernet-wpa
sudo systemctl restart systemd-networkd 

sudo batctl if add wlan0
sudo ifconfig bat0 mtu $MESH_MTU


#Setting Static Address
if [[ $STATIC_ADDRESS != "false" ]]; then
	echo Setting Static Address: $STATIC_ADDRESS
	sudo ifconfig bat0 $STATIC_ADDRESS
	fi
 
echo Provison ended.
}

function revertToWireless {
echo Using basic wireless. 
sudo rm /etc/network/interfaces.d/wlan0
echo If you are running this post start-up you will need to restart to reconnect.
}


if [[ $BOOT_TYPE = "outernet" ]]; then
		provisionMurmur
	else
		revertToWireless
	fi

#sudo systemctl restart networking

exit 0
