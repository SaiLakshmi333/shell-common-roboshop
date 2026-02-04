source ./common.sh
app_name=frontend
check_root
app_setup


dnf module disable nginx -y
validate $? "disabling nginx"

dnf module enable nginx:1.24 -y
validate $? "enabling nginx"

dnf install nginx -y
validate $? "installing nginx"

systemctl enable nginx 
systemctl start nginx 
validate $? "enabling and starting nginx"

rm -rf /usr/share/nginx/html/* 
validate $? "removing the old data"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
validate $? "downloading the web content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
validate $? "unzip the content"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
validate $? "copying nginx"

systemctl restart nginx 
validate $? "restarting nginx"

total_time