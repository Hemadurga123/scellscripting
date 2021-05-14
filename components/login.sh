#!/bin/bash

source components/common.sh
OS_PREREQ

Head "Installing Go"
apt install golang -y &>>$LOG
Stat $?

Head "Downloading Component"
cd /root/
git clone https://github.com/Hemadurga123/login.git &>>$LOG && cd login
rm -rf /etc/systemd/system/login.service
mv systemd.service /etc/systemd/system/login.service
sed -i -e "s/USERS_ENDPOINT/users.eshwarzelarsoft.host/" /etc/systemd/system/login.service
Stat $?

#Head "Get dependencies"
#go get github.com/dgrijalva/jwt-go &>>$LOG && go get github.com/labstack/echo &>>$LOG && go get github.com/labstack/echo/middleware &>>$LOG && go get github.com/labstack/gommon/log &>>$LOG && go get github.com/openzipkin/zipkin-go &>>$LOG && go get github.com/openzipkin/zipkin-go/middleware/http &>>$LOG && go get github.com/openzipkin/zipkin-go/reporter/http &>>$LOG
#Stat $?

Head "Building Package"
cd login && go build &>>$LOG
Stat $?

Head "Restarting Services"
./login
systemctl daemon-reload &>>$LOG && systemctl start login && systemctl enable login &>>$LOG
systemctl status login