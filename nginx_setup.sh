#!/bin/bash

ERROR="\033[0;31m"
SUCCESS="\033[0;32m"
WARN="\033[0;33m"
END_COLOR="\033[0m"

CERTBOT_PATH="include \/etc\/letsencrypt"
SSL_CYPHERS="ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:\!MD5;"
IP6_SSL_DIRECTIVE="listen [::]:443 ssl http2 ipv6only=on;"

if [ -z "$1" ] ||  [ -z "$2" ] ; then
  echo -e "${ERROR}2 arguments required, a domain.name and port number${END_COLOR}"
  exit 1
fi

CONFIG_PATH="/etc/nginx/sites-available/$1"

echo -e "${WARN}creating block server for ${CONFIG_PATH}${END_COLOR}"

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
echo -e "${WARN}Sleeping for 2 secs 💤 💤${END_COLOR}"

sleep 2

# symlink between available and enabled
ln -s $CONFIG_PATH /etc/nginx/sites-enabled

# open port
ufw allow $2/tcp

# check port was opened
ufw status

# reload nginx
sudo systemctl reload nginx

if [ -z "$3" ] ; then
  echo -e "${SUCCESS}####################${END_COLOR}"
  curl -I -l $1
  echo -e "${SUCCESS}$1 is ready to use @ port $2${END_COLOR}"
  exit 1
fi

echo -e "${WARN}SSL config starting${END_COLOR}"

certbot --nginx -d $1 -d www.$1

echo -e "${WARN}Sleeping for 2 secs 💤 💤${END_COLOR}"
sleep 2

echo -e "${SUCCESS}SSL certificate enabled for $1${END_COLOR}"

curl -I -l https://$1

echo -e "${WARN}Seting http2${END_COLOR}"
echo -e "${WARN}Modifying ${CONFIG_PATH}${END_COLOR}"

sed -i 's/\b443 ssl\b/& http2/' ${CONFIG_PATH}
sed -i "/\b443 ssl\b/a ${IP6_SSL_DIRECTIVE}" ${CONFIG_PATH}
sed -i "s/\(.*${CERTBOT_PATH}.*\)/#\1/" ${CONFIG_PATH}
sed -i "/\(.*${CERTBOT_PATH}.*\)/a ${SSL_CYPHERS}" ${CONFIG_PATH}

echo -e "${SUCCESS}##################  New Server Block Config ######################${END_COLOR}"
cat $CONFIG_PATH
echo -e "${SUCCESS}#########################################${END_COLOR}"

systemctl reload nginx

curl -I -l https://$1

echo -e "${SUCCESS}Done!! visit https://$1${END_COLOR}"
