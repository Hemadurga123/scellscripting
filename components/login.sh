#!/bin/bash

source components/common.sh
OS_PREREQ

Head "Installing Go"
apt install golang -y &>>$LOG
Check $?

Head "Downloading login Component"
cd /root/
git clone https://github.com/Hemadurga123/login.git &>>$LOG && cd login
rm -rf /etc/systemd/system/login.service
mv systemd.service /etc/systemd/system/login.service
sed -i -e "s/USERS_ENDPOINT/users.eshwarzelarsoft.host/" /etc/systemd/system/login.service
Check $?



Head "Building Package"
go build &>>$LOG
Check $?

Head "Restarting Services"
./login
systemctl daemon-reload &>>$LOG && systemctl start login && systemctl enable login &>>$LOG
systemctl status login