source ./common.sh
app_name=shipping
check_root
app_setup
java_setup
systemd_setup



dnf install mysql -y &>> $log_file
validate $? "installing mysql client" 

mysql -h $mysql_host -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ];then
mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql &>> $log_file
validate $? "Load Schema, Schema in database is the structure to it like"

mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $log_file
validate $? "Create app user, MySQL expects a password authentication"

mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $log_file
validate $? "load master data"

else
echo -e "data is already loaded"
fi

systemctl enable shipping &>> $log_file
validate $? "enable shipping"

systemctl start shipping &>> $log_file
validate $? "start shipping"

app_restart
total_time




