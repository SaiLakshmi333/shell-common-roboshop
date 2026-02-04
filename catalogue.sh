source ./common.sh
app_name=catalogue
check_root
app_setup
nodejs_setup
systemd_setup



#loading data into Mongodb
cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongodb.repo &>> $log_file
dnf install mongodb-mongosh -y &>> $log_file
validate $? "install mongodb" 

INDEX=$(mongosh --host $mongodb_host --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")') 

if [ $INDEX -le 0 ]; then

    mongosh --host $mongodb_host </app/db/master-data.js
    validate $? "Loading products"
else

    echo -e "$(date "+%Y-%m-%d %H-%M-%S")|Products already loaded ... $Y SKIPPING $N"

fi
app_restart
total_time









