rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo Rabbitmq App User Passowrd Missing
  exit 1
fi
# running the rabbitmq vendor script and repo file of rabbitmq and then installing rabbitmq
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
dnf install rabbitmq-server -y

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
# creating an user for the application and giving the permissions
rabbitmqctl add_user roboshop ${rabbitmq_app_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


