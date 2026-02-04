#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell_folder"
log_file="/var/log/shell_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
SCRIPT_DIR=$PWD
START_TIME=$(date +%s)
mongodb_host=mongodb.devopswithsai.online
redis_host=redis.devopswithsai.online
mysql_host=mysql.devopswithsai.online


mkdir -p $log_folder 
echo "$(date "+%Y-%m-%d %H-%M-%s") | script started executing at : $(date)" | tee -a $log_file

check_root(){
if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access $N" | tee -a $log_file 
exit 1
fi
}

nodejs_setup(){
dnf module disable nodejs -y &>> $log_file
validate $? "disable old nodejs" 

dnf module enable nodejs:20 -y &>> $log_file
validate $? "enable nodejs" 

dnf install nodejs -y &>>$log_file
validate $? "installing nodejs" 

npm install &>>$log_file
validate $? "installing dependencies" 

}

app_setup(){
    #creating system user
id roboshop &>>$log_file
if [ $? -ne 0 ];then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $log_file
validate $? "creating system user" 
else
echo -e "roboshop user already exist $Y skipping $n" &>> $log_file 
fi
#downloading the app
mkdir -p /app &>>$log_file
validate $? "creating directory" 

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>> $log_file
validate $? "downloading $app_name code" 

cd /app &>>$log_file
validate $? "moving app directory" 

rm -rf /app/* &>>$log_file
validate $? "removing the existing code" 

unzip /tmp/$app_name.zip &>> $log_file
validate $? "unzip $app_name code" 
}

java_setup(){
dnf install maven -y
validate $? "installing maven" &>> $log_file  

cd /app &>> $log_file
mvn clean package &>> $log_file
mv target/$app_name-1.0.jar $app_name.jar &>> $log_file
validate $? "clean" 
}

systemd_setup(){
cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>> $log_file
validate $? "copy $app_name service" 

systemctl daemon-reload &>> $log_file
validate $? "daemon reloaded successfully" 

systemctl enable $app_name &>> $log_file
validate $? "enabled $app_name" 

systemctl start $app_name &>> $log_file
validate $? "started $app_name" 

}

app_restart(){
    systemctl restart $app_name
validate $? "Restarting $app_name"
}

validate(){
    if [ $1 -ne 0 ];then
    echo -e "$(date "+%Y-%m-%d %H-%M-%S")|$R $2 is failed $N" &>> $log_file
    exit 1
    else
    echo -e "$(date "+%Y-%m-%d %H-%M-%S")|$G $2 is success $N" &>> $log_file
    fi
}

total_time(){
    END_TIME=$(date +%s)
    total_time=$(($END_TIME-$START_TIME))
    echo -e "Script executed  in : $G $total_time $N" | tee -a $log_file
}

