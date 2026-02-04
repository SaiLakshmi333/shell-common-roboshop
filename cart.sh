#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell_folder/"
log_file="$log_folder/$0.log"
R="\e[31m"
G="\e[32m" 
Y="\e[33m"
B="\e[34m" 
N="\e[0m"
SCRIPT_DIR=$PWD
mongodb_host_id="mongodb.devopswithsai.online"
redis_host_id="redis.devopswithsai.online"

if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access $N"
exit 1
fi

mkdir -p $log_folder
validate(){
    if [ $1 -ne 0 ];then
    echo -e "$2 is $R failed $N"
    else
    echo -e "$2 is $G success $N"
    fi
}

dnf module disable nodejs -y  &>>$log_file
dnf module enable nodejs:20 -y &>>$log_file
validate $? "disabling and enabling nodejs"

dnf install nodejs -y &>>$log_file
validate $? "installing nodejs"


id roboshop
if [ $? -ne 0 ];then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system cart" roboshop &>>$log_file
validate $? "user added"
else
echo "user already exist"
fi

mkdir -p /app &>>$log_file
validate $? "app directory created"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>>$log_file
validate $? "downloaded the cart content"


cd /app &>>$log_file
validate $? "Go to app directory"

rm -rf /app/* &>>$log_file
validate $? "removed existing data"

unzip /tmp/cart.zip &>>$log_file
validate $? "unzipped the content to access"

cd /app &>>$log_file
npm install &>>$log_file
validate $? "npm dependencies installed"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>>$log_file
validate $? "copied cart service"

systemctl daemon-reload &>>$log_file
validate $? "daemon-reloaded"

systemctl enable cart &>>$log_file
systemctl start cart &>>$log_file
validate $? "ebable and disable"









