# copying the shiiping service file
cp shipping.service /etc/systemd/system/shipping.service
# installing maven
dnf install maven -y
# adding the user and created an directory and also downloading the shipping content and then installing required dependencies
useradd roboshop
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar
# installing the mysql and loading the schema
dnf install mysql -y
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql

systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping
