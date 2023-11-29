# copying the dispatch service file
cp dispatch.service /etc/systemd/system/dispatch.service
# installing golang
dnf install golang -y
# adding the user and creating an directory and also downloading the dispatch content and then installing required dependencies
useradd roboshop
mkdir /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip
cd /app
go mod init dispatch
go get
go build

systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch