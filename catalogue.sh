# copying the catalogue service file
echo -e ">>>>>>>>>>>>>>>>> Create Catalogue Service file <<<<<<<<<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
# copying the mongo repo file
echo -e ">>>>>>>>>>>>>>>>> create Catalogue Mongo repo file <<<<<<<<<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
# disabling,enabling and installing the nodejs
echo -e ">>>>>>>>>>>>>>>>> Disabling,Enabling and installing nodeJS <<<<<<<<<<<<<<<<<<<<<"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
# adding the user and created an directory and also downloading the catalogue content and then installing required dependencies
echo -e ">>>>>>>>>>>>>>>>> Creating Application User <<<<<<<<<<<<<<<<<<<<<"
useradd roboshop
echo -e ">>>>>>>>>>>>>>>>> Creating application Directory <<<<<<<<<<<<<<<<<<<<<"
mkdir /app
echo -e ">>>>>>>>>>>>>>>>> Downloading application Content <<<<<<<<<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo -e ">>>>>>>>>>>>>>>>> Extracting Application Content <<<<<<<<<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app
echo -e ">>>>>>>>>>>>>>>>> Downloading NodeJS Dependencies <<<<<<<<<<<<<<<<<<<<<"
npm install
# installing the mongodb shell
echo -e ">>>>>>>>>>>>>>>>> Installing Mongodb Client <<<<<<<<<<<<<<<<<<<<<"
dnf install mongodb-org-shell -y
echo -e ">>>>>>>>>>>>>>>>> Loading Catalogue Schema <<<<<<<<<<<<<<<<<<<<<"
mongo --host mongodb.pavansai.online </app/schema/catalogue.js
echo -e ">>>>>>>>>>>>>>>>> Starting Catalogue Service <<<<<<<<<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

