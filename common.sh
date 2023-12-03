func_nodejs(){
 log=/tmp/roboshop.log
# copying the ${component} service file
echo -e "\e[37m >>>>>>>>>>>>>>>>> Create ${component} Service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
# copying the mongo repo file
echo -e "\e[37m >>>>>>>>>>>>>>>>> create ${component} Mongo repo file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
# disabling,enabling and installing the nodejs
echo -e "\e[37m >>>>>>>>>>>>>>>>> Disabling,Enabling and installing nodeJS <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y &>>${log}
dnf module enable nodejs:18 -y &>>${log}
dnf install nodejs -y &>>${log}
# adding the user and created an directory and also downloading the ${component} content and then installing required dependencies
echo -e "\e[37m >>>>>>>>>>>>>>>>> Creating Application User <<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Removing existing Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Creating application Directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Downloading application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Extracting Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/${component}.zip &>>${log}
cd /app
echo -e "\e[37m >>>>>>>>>>>>>>>>> Downloading NodeJS Dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}
# installing the mongodb shell
echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Mongodb Client <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Loading ${component} Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.pavansai.online </app/schema/${component}.js &>>${log}
echo -e "\e[37m >>>>>>>>>>>>>>>>> Starting ${component} Service <<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>>${log}
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}
}
