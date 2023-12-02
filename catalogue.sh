log=/tmp/roboshop.log
# copying the catalogue service file
echo -e "\e[37m >>>>>>>>>>>>>>>>> Create Catalogue Service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
# copying the mongo repo file
echo -e "\e[37m >>>>>>>>>>>>>>>>> create Catalogue Mongo repo file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
# disabling,enabling and installing the nodejs
echo -e "\e[37m >>>>>>>>>>>>>>>>> Disabling,Enabling and installing nodeJS <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y &>>${log}
dnf module enable nodejs:18 -y &>>${log}
dnf install nodejs -y &>>${log}
# adding the user and created an directory and also downloading the catalogue content and then installing required dependencies
echo -e "\e[37m >>>>>>>>>>>>>>>>> Creating Application User <<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Removing existing Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Creating application Directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Downloading application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Extracting Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}
cd /app &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Downloading NodeJS Dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}
# installing the mongodb shell
echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Mongodb Client <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Loading Catalogue Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.pavansai.online </app/schema/catalogue.js &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Starting Catalogue Service <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}

