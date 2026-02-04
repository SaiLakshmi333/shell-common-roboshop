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

mkdir -p $log_folder 
echo "$(date "+%Y-%m-%d %H-%M-%s") | script started executing at : $(date)" | tee -a $log_file

check_root(){
if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access $N" | tee -a $log_file 
exit 1
fi
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
    total_time = $(($START_TIME-$END_TIME))
    echo -e "Script executed  in : $G $total_time $N" | tee -a $log_file
}
