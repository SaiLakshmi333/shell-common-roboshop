source ./common.sh

check_root
cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file
validate $? "copying" 

dnf install mongodb-org -y &>>$log_file
validate $? "installing mongodb" 

systemctl enable mongod &>>$log_file
validate $? "enabling mongodb" 

systemctl start mongod &>>$log_file
validate $? "starting mongodb" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$log_file
validate $? "allowing remote connections" 

systemctl restart mongod &>>$log_file
validate $? "restarting mongodb" 

total_time
