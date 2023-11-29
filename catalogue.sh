# copying the catalogue service file
cp catalogue.service /etc/systemd/system/catalogue.service
# copying the mongo repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo
# disabling,enabling and installing the nodejs
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
# adding the user and created an directory and also downloading the catalogue content and then installing required dependencies
useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
# installing the mongodb shell
dnf install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

