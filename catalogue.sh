# copying the catalogue service file
echo -e "\e[34m >>>>>>>>>>>>>>>>> Create Catalogue Service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
# copying the mongo repo file
echo -e "\e[34m >>>>>>>>>>>>>>>>> create Catalogue Mongo repo file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
# disabling,enabling and installing the nodejs
echo -e "\e[34m >>>>>>>>>>>>>>>>> Disabling,Enabling and installing nodeJS <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
# adding the user and created an directory and also downloading the catalogue content and then installing required dependencies
echo -e "\e[34m >>>>>>>>>>>>>>>>> Creating Application User <<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop
echo -e "\e[34m >>>>>>>>>>>>>>>>> Creating application Directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[34m >>>>>>>>>>>>>>>>> Downloading application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e "\e[34m >>>>>>>>>>>>>>>>> Extracting Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app
echo -e "\e[34m >>>>>>>>>>>>>>>>> Downloading NodeJS Dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
npm install
# installing the mongodb shell
echo -e "\e[34m >>>>>>>>>>>>>>>>> Installing Mongodb Client <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y
echo -e "\e[34m >>>>>>>>>>>>>>>>> Loading Catalogue Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.pavansai.online </app/schema/catalogue.js
echo -e "\e[34m >>>>>>>>>>>>>>>>> Starting Catalogue Service <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

