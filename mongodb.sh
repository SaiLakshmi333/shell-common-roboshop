source ./common.sh

check_root
cp mongodb.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y 
validate $? "installing mongodb" &>>$log_file

systemctl enable mongod
validate $? "enabling mongodb" &>>$log_file

systemctl start mongod 
validate $? "starting mongodb" &>>$log_file

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "allowing remote connections" &>>$log_file

systemctl restart mongod
validate $? "restarting mongodb" &>>$log_file

total_time
