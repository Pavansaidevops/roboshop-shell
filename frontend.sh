# installing nginx
yum install nginx -y
# copying the roboshop configuration file
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
# removing the default nginx page
rm -rf /usr/share/nginx/html/*
# downloading the original roboshop content
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
# unzipping the roboshop files
unzip /tmp/frontend.zip

systemctl enable nginx
systemctl restart nginx




