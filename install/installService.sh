#! /bin/bash

echo Provision Raspbian System for outernet 1.00


#Moving Service from home to usr
if mv -f $HOME/outernet/install/service/outernet-service.sh /usr/local/bin/; then
  echo "File moved successfully."
else
  echo "Error: The file could not be moved."
  exit 1
fi

#Setting as exacuatable 
sudo chmod +x /usr/local/bin/outernet-service.sh
