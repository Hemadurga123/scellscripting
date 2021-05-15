#!/bin/bash

source components/common.sh
DN="eshwarzelarsoft.host"
OS_PREREQ

Head "Installing Nginx"
apt install nginx -y &>>$LOG
systemctl restart nginx
Check $?

Head "Install npm"
apt install npm -y &>>$LOG
Check $?

DOWNLOAD_COMPONENT

Head "Unzip Downloaded Archive"
cd /var/www/html &&rm -rf vue && mkdir vue && cd vue && unzip -o /tmp/frontend.zip &>>$LOG && rm -rf frontend.zip  && rm -rf frontend && mv frontend-main frontend && cd frontend
Check $?

Head "Update Nginx Configuration"
sed -i 's|/var/www/html|/var/www/html/vue/frontend/dist|g' /etc/nginx/sites-enabled/default
Check $?

Head "pass the end points in service file"
cd /var/www/html/vue/frontend
cd config
export AUTH_API_ADDRESS=http://login.${DN}:8080
export TODOS_API_ADDRESS=http://todo.${DN}:8080
Check $?

Head "update frontend configuration"
cd /var/www/html/vue/frontend  && sudo npm install --unsafe-perm sass sass-loader node-sass wepy-compiler-sass &>>$LOG && npm run build &>>$LOG
Check $?

head "Start Npm service"
npm start
Check $?