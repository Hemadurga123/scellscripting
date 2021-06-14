
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

Head "update frontend configuration"
cd /var/www/html/vue/frontend  && sudo npm install --unsafe-perm sass sass-loader node-sass wepy-compiler-sass &>>$LOG && npm run build &>>$LOG
Check $?

Head "update the end points in service file"
sed -i '32 s/127.0.0.1/login.$DN/g' /var/www/html/vue/frontend/config/index.js
sed -i '36 s/127.0.0.1/todo.$DN/g' /var/www/html/vue/frontend/config/index.js
sed -i '40 s/127.0.0.1/0.0.0.0/g' /var/www/html/vue/frontend/config/index.js
Check $?

head "Start Npm service"
npm start
Check $?