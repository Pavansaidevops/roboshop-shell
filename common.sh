log=/tmp/roboshop.log
func_exit_status(){

  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e [0m"
  else
    echo -e "\e[31m FAILURE \e [0m"
  fi

}

func_apppreq(){
  # copying the ${component} service file
   echo -e "\e[37m >>>>>>>>>>>>>>>>> Create ${component} Service file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
   cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

   func_exit_status

  # adding the user and created an directory and also downloading the ${component} content and then installing required dependencies
  echo -e "\e[37m >>>>>>>>>>>>>>>>> Adding Application User <<<<<<<<<<<<<<<<<<<\e[0m"
  id roboshop &>>{log}
  if [ $? -ne 0 ]; then
  useradd roboshop &>>${log}
  fi

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Removing existing Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  echo -e "\e[37m >>>>>>>>>>>>>>>>> Creating application Directory <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  echo -e "\e[37m >>>>>>>>>>>>>>>>> Downloading application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

  func_exit_status

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Extracting Application Content <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip &>>${log}

  func_exit_status

}

func_systemd(){

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Starting ${component} Service <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}

  func_exit_status

}

func_schema_setup(){

  if [ "${schema_type}" == "mongodb" ]; then
   # installing the mongodb shell
     echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Mongodb Client <<<<<<<<<<<<<<<<<<<<<<\e[0m"
     dnf install mongodb-org-shell -y &>>${log}

     func_exit_status

     echo -e "\e[37m >>>>>>>>>>>>>>>>> Loading ${component} Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
     mongo --host mongodb.pavansai.online </app/schema/${component}.js &>>${log}

     func_exit_status

  fi

  if [ "${schema_type}" == "mysql" ]; then
     # installing the mysql and loading the schema
       echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Mysql <<<<<<<<<<<<<<<<<<<<<<\e[0m"
       dnf install mysql -y &>>${log}

       func_exit_status

       echo -e "\e[37m >>>>>>>>>>>>>>>>> Loading ${component} Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m"
       mysql -h mysql.pavansai.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

       func_exit_status

   fi
}

func_nodejs(){
  # copying the mongo repo file
  echo -e "\e[37m >>>>>>>>>>>>>>>>> create ${component} Mongo repo file <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  func_exit_status

  # disabling,enabling and installing the nodejs
  echo -e "\e[37m >>>>>>>>>>>>>>>>> Disabling,Enabling and installing nodeJS <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y &>>${log}
  dnf module enable nodejs:18 -y &>>${log}
  dnf install nodejs -y &>>${log}

  func_exit_status

  func_apppreq

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Downloading NodeJS Dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}

  func_exit_status

  func_schema_setup

  func_systemd

}

func_java(){
  # installing maven
  echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Maven <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf install maven -y &>>${log}

  func_exit_status

  func_apppreq

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Build ${component} Service <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}

  func_exit_status

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Renaming ${component} file name <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  mv target/${component}-1.0.jar ${component}.jar &>>${log}

  func_schema_setup

  func_systemd

}

func_python(){
  # installing python
  echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Python <<<<<<<<<<<<<<<<<<\e[0m"
  dnf install python36 gcc python3-devel -y &>>{log}

  func_exit_status

  func_apppreq

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Python Requirements <<<<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>{log}

  func_exit_status
  
  func_systemd

}

func_go(){
  # installing golang
  echo -e "\e[37m >>>>>>>>>>>>>>>>> Installing Golang <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  dnf install golang -y &>>${log}

  func_exit_status

  func_apppreq

  echo -e "\e[37m >>>>>>>>>>>>>>>>> Build ${component} Service <<<<<<<<<<<<<<<<<<<<<<\e[0m"
  go mod init dispatch &>>${log}
  go get &>>${log}
  go build &>>${log}

  func_exit_status

  func_systemd

}