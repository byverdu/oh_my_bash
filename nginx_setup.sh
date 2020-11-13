#!/bin/bash

VAR_WWW="var/www/$1/html"

echo "creating folder/chown/chmod at ${VAR_WWW}"

sudo mkdir -p $VAR_WWW
sudo chown -R $USER:$USER $VAR_WWW  
sudo chmod -R 755 $VAR_WWW