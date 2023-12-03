source common.sh
# installing nginx
echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Nginx <<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf install nginx -y

func_exit_status

# copying the roboshop configuration file
echo -e "\e[37m >>>>>>>>>>>>>>>>> Copying Roboshop Configuration <<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

func_exit_status

# removing the default nginx page
echo -e "\e[37m >>>>>>>>>>>>>>>>> Removing Default Nginx Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

func_exit_status

# downloading the original roboshop content
echo -e "\e[37m >>>>>>>>>>>>>>>>> Downloading Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

func_exit_status

cd /usr/share/nginx/html
# unzipping the roboshop files
echo -e "\e[37m >>>>>>>>>>>>>>>>> Unzipping Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip

func_exit_status

systemctl enable nginx
systemctl restart nginx

func_exit_status




