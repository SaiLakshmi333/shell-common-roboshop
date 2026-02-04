source ./common.sh
app_name=mysql
check_root


dnf install mysql-server -y &>>$log_file
validate $? "installing mysql"

systemctl enable mysqld &>>$log_file
systemctl start mysqld  &>>$log_file
validate $? "ebable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file #get the password from user 
validate $? "setup root password"

total_time