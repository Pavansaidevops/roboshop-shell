# copying the payment service file
cp payment.service /etc/systemd/system/payment.service
# installing python
dnf install python36 gcc python3-devel -y
# adding the user and created an directory and also downloading the payment content and installing required dependencies
useradd roboshop
mkdir /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
cd /app
pip3.6 install -r requirements.txt

systemctl daemon-reload
systemctl enable payment
systemctl restart payment
