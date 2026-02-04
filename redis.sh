source ./common.sh
app_name=redis
check_root


dnf module disable redis -y &>>$log_file
validate $? "disabling redis"

dnf module enable redis:7 -y &>>$log_file
validate $? "enabling redis"

dnf install redis -y &>>$log_file
validate $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$log_file
validate $? "allowing all connections"

systemctl enable redis &>>$log_file
validate $? "enabling redis" 

systemctl start redis &>>$log_file
validate $? "starting redis"

total_time