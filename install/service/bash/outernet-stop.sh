#!/bin/bash
#Stops Outernet and restores wireless connection

echo Removing old Network Files...
sudo rm /etc/systemd/network/10-wlan0-mesh.network
sudo rm /etc/systemd/network/20-bat0.network
sudo rm /etc/systemd/network/20-bat0.netdev
echo Complete!

echo Reloading daemons
sudo systemctl daemon-reload
echo Complete!

echo Stopping outernet services

sudo systemctl stop outernet-wpa
sudo systemctl stop outernet
echo Complete!

Echo Restarting normal network stack
#sudo systemctl restart wpa_supplicant
sudo systemctl restart systemd-networkd
sudo systemctl restart NetworkManager
echo Complete!
echo Reversion complete
