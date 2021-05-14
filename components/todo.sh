#!/bin/bash

source components/common.sh
OS_PREREQ


Head "Installing Npm"
sudo apt install npm -y &>>$LOG
stat $?

Head "Downloading COMPONENT"
cd /root/
git clone https://github.com/Hemadurga123/todo.git &>>$LOG && cd todo
rm -rf /etc/systemd/system/todo.service
mv systemd.service /etc/systemd/system/todo.service
sed -i -e "s/REDIS_ENDPOINT/redis.eshwarzelarsoft.host/" /etc/systemd/system/todo.service
Stat $?

Head "Buliding the code"
npm install &>>$LOG && npm run build &>>$LOG
Stat $?

Head "Starting the service"
npm start
systemctl daemon-reload &>>$LOG && systemctl start todo && systemctl enable todo &>>$LOG
systemctl status todo
