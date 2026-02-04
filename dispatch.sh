source ./common.sh
app_name=catalogue
check_root
app_setup
golang_setup
systemd_setup



cd /app &>>$log_file
go mod init dispatch &>>$log_file
go get &>>$log_file
go build &>>$log_file
validate $? "install dependencies"
total_time

