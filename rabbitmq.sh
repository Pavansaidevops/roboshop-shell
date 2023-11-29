# running the rabbitmq vendor script and repo file of rabbitmq and then installing rabbitmq
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
dnf install rabbitmq-server -y

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
# creating an user for the application and giving the permissions
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


