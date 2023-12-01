# installing the redis repo file and enabling the required redis version and installing the redis
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
dnf install redis -y
#Update listen address from 127.0.0.1 to 0.0.0.0

sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
systemctl enable redis
systemctl restart redis
