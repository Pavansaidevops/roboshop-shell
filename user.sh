# copying the user service file
cp user.service /etc/systemd/system/user.service
# copying the mongo repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo
# disabling the default nodejs and enabling the required nodejs and then installing nodejs
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
# adding the user and created an directory and also downloading the user content and then installing required dependencies
useradd roboshop
mkdir /app
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app
npm install
# installing the mongodb shell and loading the schema
dnf install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js

systemctl daemon-reload
systemctl enable user
systemctl restart user