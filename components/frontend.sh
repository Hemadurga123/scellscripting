#!/bin/bash


apt update

Head " Install Nginx"
apt install nginx -y


Head " Install node 8 "
curl –sL https://deb.nodesource.com/setup_8.x | sudo –E bash -
sudo apt-get install –y nodejs

apt install npm -y

Head "download the content and deploy under the Nginx path"
cd /var/www/html && mkdir sample && cd /var/www/html/sample

Head "fetch the git clone"
git clone https://github.com/zelar-soft-todoapp/frontend.git
cd /etc/nginx/sites-available
#vim default
cd /var/www/html/sample/frontend/
stat $?

Head "Install Npm"
npm install
#npm run build
cd /etc/nginx/sites-available
sed -i 's|/var/www/html|/var/www/html/sample/frontend/dist|g' /etc/nginx/sites-available/default
npm run build
npm start

#Head "Login and todo Ip address"
#cd /var/www/html/avk/frontend
#cd config
#vim index.js &>>$LOG

Head "restart the service once to effect the changes"
systemctl restart nginx
