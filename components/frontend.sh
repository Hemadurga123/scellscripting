#!/bin/bash

source components/common.sh

OS_PREREQ

Head "Installing Nginx and Npm"
sudo apt install nginx -y &>>$LOG
sudo apt install npm -y &>>$LOG

stat $?

Head "Downloading COMPONENT"
cd /var/www/html && git clone https://github.com/Hemadurga123/frontend.git &>>$LOG && cd frontend

Head "Building the Code"
npm install &>>$LOG && npm run build &>>$LOG
stat $?


Head "Moving Conf file"
mv frontend.conf /etc/nginx/sites-enabled/default
sed -i -e "s/LOGIN_ENDPOINT/login.eshwarzelarsoft.host/" -e "s/TODO_ENDPOINT/todo.eshwarzelarsoft.host/" /etc/nginx/sites-enabled/default
stat $?

Head "Exporting Ip's"
export AUTH_API_ADDRESS=http://login.eshwarzelarsoft.host:8080
export TODOS_API_ADDRESS=http://todo.eshwarzelarsoft.host:8080
stat $?

Head "Starting Npm Service"
npm start
systemctl restart nginx &>>$LOG && systemctl start nginx &>>$LOG systemctl enable nginx &>>$LOG
systemctl status nginx