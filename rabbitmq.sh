source ./common.sh
app_name=rabbitmq
check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
validate $? "copying repo"

dnf install rabbitmq-server -y &>>$log_file
validate $? "installing rabbitmq servr"

systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
validate $? "enable and start rabbitmq servr"

rabbitmqctl add_user roboshop roboshop123 &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

total_time
