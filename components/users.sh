#!/bin/bash

#source components/common.sh
#OS_PREREQ

Head "install java version java-8"
apt install openjdk-8-jdk -y &>>$LOG
Check $?

Head "Install maven"
apt install maven -y &>>$LOG
Check $?

Head "fetch git code"
git clone https://github.com/zelar-soft-todoapp/users.git &>>$LOG


Head "entering into the directory"
cd users && mvn clean package &>>$LOG
Check $?

Head "entering into the directory"
cd target
Check $?


Head "moving the directory"
mv users-api-0.0.1.jar users.jar &>>$LOG
Check $?

Head "setup the service with systemctl"
mv /home/ubuntu/users/systemd.service /etc/systemd/system/users.service && systemctl daemon-reload && systemctl start users && systemctl enable users &>>LOG
Check $?
