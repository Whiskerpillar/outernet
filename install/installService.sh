#! /bin/bash

echo Provision Raspbian System for outernet 1.00


#Moving Service from home to usr
mv -f ~/outernet/install/service/outernet-service.sh /usr/local/bin/

#Setting as exacuatable 
sudo chmod +x /usr/local/bin/outernet-service.sh
