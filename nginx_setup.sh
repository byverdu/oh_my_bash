#!/bin/bash

if [ -z "$1" ] ||  [ -z "$2" ] ; then
  echo "2 arguments required a domain.name and port number"
  exit 1
fi

CONFIG_PATH="/etc/nginx/sites-available/$1"

echo "creating block server for ${CONFIG_PATH}"

echo "server {
  server_name $1 www.$1;

  location / {
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
    proxy_pass  http://localhost:$2;
  }
}" >> $CONFIG_PATH
