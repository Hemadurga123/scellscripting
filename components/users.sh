#!/bin/bash

source components/common.sh
OS_PREREQ

Head "Installing the Java and Maven"
apt install openjdk-8-jdk -y &>>$LOG && apt install maven -y &>>$LOG
Check $?


Head "Downloading the users component"
cd /root/
git clone https://github.com/Hemadurga123/users.git &>>$LOG && cd users
rm -rf /etc/systemd/system/users.service

Head "Updating Endpoints"
mv systemd.service /etc/systemd/system/users.service
sed -i -e "s/Login_Endpoint/login.eshwarzelarsoft.host/" /etc/systemd/system/users.service
Check $?

Head "Building the Code"
mvn clean &>>$LOG && mvn clean package &>>$LOG
Check $?

Head "Starting the Service"
systemctl daemon-reload &>>$LOG && systemctl start users && systemctl enable users &>>$LOG
systemctl status users
java -jar target/users-api-0.0.1.jar