#!/bin/bash

apt update
apt install -y nginx
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
node -v
apt install -y npm >/dev/null
npm -v
cd /var/www/html/ && mkdir jio
git clone https://github.com/zelar-soft-todoapp/frontend.git
cd  /var/www/html/jio/frontend
npm install
cd /etc/nginx/sites-available/
sed -i 's|/var/www/html|/var/www/html/frontend/dist|g' /etc/nginx/sites-available/default
#vim default
cd /var/www/html/jio/frontend/
npm install
npm run build
npm start

