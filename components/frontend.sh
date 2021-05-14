#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Installing Nginx and Npm"
sudo apt install nginx -y &>>$LOG
sudo apt install npm -y &>>$LOG
Check $?

Head "Downloading frontend COMPONENT"
cd /var/www/html && git clone https://github.com/Hemadurga123/frontend.git &>>$LOG && cd frontend

Head "Building the Code"
npm install &>>$LOG && npm run build &>>$LOG
Check $?


Head "Moving the Config file"
mv frontend.conf /etc/nginx/sites-enabled/default
sed -i -e "s/LOGIN_ENDPOINT/login.eshwarzelarsoft.host/" -e "s/TODO_ENDPOINT/todo.eshwarzelarsoft.host/" /etc/nginx/sites-enabled/default
Check $?

Head "Exporting the  Ip adresses"
export AUTH_API_ADDRESS=http://login.eshwarzelarsoft.host:8080
export TODOS_API_ADDRESS=http://todo.eshwarzelarsoft.host:8080
Check $?

Head "Starting the Npm Service"
npm start
systemctl restart nginx &>>$LOG && systemctl start nginx &>>$LOG systemctl enable nginx &>>$LOG
systemctl status nginx
