# OceanDigital Setup Steps

```bash
# After create droplet add ssh conf

Host ssh_name
  User user_name
  HostName droplet_ip
  IdentityFile path_to_ssh_private_key

> ssh ssh_name
```

## [Server setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04)

```bash
# as root from > ssh ssh_name
> adduser user_name
> usermod -aG sudo user_name
# ufw => Uncomplicated Firewall
> ufw app list
> ufw allow OpenSSH
> ufw enable
# to copy authorized_keys from root to user_name
> rsync --archive --chown=user_name:user_name .ssh/ /home/user_name/.ssh
```

## Server setup for user_name

```bash
# set git config
> git config --global user.name "byverdu"
> git config --global user.email "byverdu@gmail.com"

# install zsh
> sudo apt install zsh
> sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
> sudo apt install nodejs

# yarn
> curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
> echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
> sudo apt-get install yarn
# add binaries to the path
> yarn global bin # /home/byverdu/.yarn/bin
> yarn config set prefix /home/byverdu/.yarn
> echo export PATH="$PATH:`yarn global bin`" >> .zshrc
> yarn global add pm2
> pm2 # :)
```

## [Install nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04)

```bash
> sudo apt update
> sudo apt install nginx
> sudo ufw allow 'Nginx HTTP' # not HTTPS because SSL is not ready yet
> systemctl status nginx # all :)

# Server blocks config
# create a record for every single domain that needs to be hosted

# go to root folder
> cd /
> sudo mkdir -p var/www/test.byverdu.es/html
> sudo chown -R $USER:$USER var/www/test.byverdu.es/html
> sudo chmod -R 755 var/www/test.byverdu.es/html

# create html file to access it without node app
> nano var/www/test.byverdu.es/html/index.html

# For Nginx to serve content, a server block has to be created with the correct directives. Instead of modifying the default configuration create a new one

> sudo nano /etc/nginx/sites-available/test.byverdu.es
# nginx reads the sites-enabled folder at start-up
> sudo ln -s /etc/nginx/sites-available/test.byverdu.es /etc/nginx/sites-enabled

# Config to serve Application with proxy

# server {
#   root /var/www/test.byverdu.es/html;
#   server_name test.byverdu.es www.test.byverdu.es;

#   location / {
#     proxy_http_version 1.1;
#     proxy_set_header Upgrade $http_upgrade;
#     proxy_set_header Connection 'upgrade';
#     proxy_set_header Host $host;
#     proxy_cache_bypass $http_upgrade;
#     proxy_pass  http://localhost:9090;
#   }
# }

# uncomment -> server_names_hash_bucket_size 64;
> sudo nano /etc/nginx/nginx.conf

# port needs to be open in order to access the app
> sudo ufw allow 9090/tcp
> sudo systemctl restart nginx
```

## [Enable https in nginx](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04)

```bash
# install certbot
> sudo add-apt-repository ppa:certbot/certbot
> sudo apt install python3-certbot-nginx

# allow nginx to use http and https
> sudo ufw allow 'Nginx Full'
> sudo ufw delete allow 'Nginx HTTP'

# create certificates for domains specified at server_name
> sudo certbot --nginx -d test.byverdu.es -d www.test.byverdu.es
> sudo systemctl nginx reload

# Result config
# server {
#   root /var/www/test.byverdu.es/html;
#   server_name test.byverdu.es www.test.byverdu.es;

#   location / {
#     proxy_http_version 1.1;
#     proxy_set_header Upgrade $http_upgrade;
#     proxy_set_header Connection 'upgrade';
#     proxy_set_header Host $host;
#     proxy_cache_bypass $http_upgrade;
#     proxy_pass  http://localhost:9090;
#   }


#   listen 443 ssl;
#   ssl_certificate /etc/letsencrypt/live/test.byverdu.es/fullchain.pem;
#   ssl_certificate_key /etc/letsencrypt/live/test.byverdu.es/privkey.pem;
#   include /etc/letsencrypt/options-ssl-nginx.conf;
#   ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
# }

# # Redirection part
# server {
#   if ($host = www.test.byverdu.es) {
#     return 301 https://$host$request_uri;
#   }

#   if ($host = test.byverdu.es) {
#     return 301 https://$host$request_uri;
#   }


#   server_name test.byverdu.es www.test.byverdu.es;
#   listen 80;
#   return 404;
# }
```

> Let’s Encrypt’s certificates are only valid for ninety days. This is to encourage users to automate their certificate renewal process. The certbot package adds a renew script to /etc/cron.d. This script runs twice a day and will automatically renew any certificate that’s within thirty days of expiration.\
> `> sudo certbot renew --dry-run`

## [Enable http/2 in nginx](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-with-http-2-support-on-ubuntu-18-04#step-1-%E2%80%94-enabling-http2-support)

```bash
# edit the server block configuration file for your domain
> sudo nano /etc/nginx/sites-available/test.byverdu.es

# add the http2 protocol to the list directives
> listen [::]:443 ssl http2 ipv6only=on;
> listen 443 http2 ssl;

# comment out this line
> include /etc/letsencrypt/options-ssl-nginx.conf;

# and append the below one
> ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;

# reload config and verify it's been enabled
> sudo systemctl reload nginx
> curl -I -L https://your_domain

# Enable HTTP Strict Transport Security (HSTS) to avoid having the redirects from http to https
> sudo nano /etc/nginx/nginx.conf
# find "include /etc/nginx/sites-enabled/*;" and append below line
> add_header Strict-Transport-Security "max-age=15768000; includeSubDomains" always;
```
