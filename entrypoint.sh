#!/bin/bash

if [ -f /spt-server/SPT.Server ]; then
  appHash=$(md5sum /app/spt-server/SPT.Server | awk '{ print $1 }')
  programHash=$(md5sum /spt-server/SPT.Server | awk '{ print $1 }')
  if [ "$appHash" = "$programHash" ]; then
    echo "MD5 verification successful!"
  else
    echo "MD5 mismatch, copy files to /spt-server."
    cp -r /app/spt-server /
    echo "Finished!"
  fi
else
  echo "Program is not found, copy files to /spt-server."
  cp -r /app/spt-server /
  echo "Finished!"
fi

cd /spt-server

if [ -z "$backendIp" ]; then
  IP=$(hostname -I | awk '{print $1}')
else
  IP=$backendIp
fi

if [ -z "$backendPort" ]; then
  PORT=6969
else
  PORT=$backendPort
fi

sed -i "0,/127.0.0.1/s/127.0.0.1/${IP}/" SPT_Data/Server/configs/http.json
sed -i "s/6969/${PORT}/g" SPT_Data/Server/configs/http.json

chmod +x SPT.Server && ./SPT.Server