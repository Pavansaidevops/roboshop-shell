mysql_root_password=$1
if [ -z "$mysql_root_password" ]; then
  echo Input Password Missing
  exit 1
fi
# copying the mysql repo file
cp mysql.repo /etc/yum.repos.d/mysql.repo
# # disabling the default mysql module and installing mysql
dnf module disable mysql -y
dnf install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld
# changing the default root password and creating the password
mysql_secure_installation --set-root-pass ${mysql_root_password}
