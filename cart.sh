# copying the cart service file
cp cart.service /etc/systemd/system/cart.service
# disabling the default nodejs and enabling the required nodejs and then installing nodejs
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
# adding the user and created an directory and also dowloading the cart content and then installing required dependencies
useradd roboshop
mkdir /app
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install

systemctl daemon-reload
systemctl enable cart
systemctl restart cart