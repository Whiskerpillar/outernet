#used for the outernet service to revert it's changes


echo Removing old Network Files...
sudo rm /etc/systemd/network/10-wlan0-mesh.network
sudo rm /etc/systemd/network/20-bat0.network
sudo rm /etc/systemd/network/20-bat0.netdev
echo

sudo systemctl daemon-reload

sudo systemctl stop outernet
sudo systemctl stop outernet-wpa

sudo systemctl restart wpa_supplicant
sudo systemctl restart systemd-networkd
sudo systemctl restart NetworkManager
