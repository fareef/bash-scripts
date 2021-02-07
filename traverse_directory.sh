#write the shell script for the following.
#In a directory contains six sub directories called a,b,c,d,e,f.
#Go to each directory and read the files contained in a directory one by one and
#check the below three conditions.
 #a. If we received a file today, then check file is corrupted or not.
 #b. Find the average file size of the last 30 days and compare with today's file size.If there is a deviation in file size +/- by 20% then send a mail.
 #c. If today's File Time difference is more or less than 2 hours compared with the average time of the last 30 days then send a mail.

#!/bin/bash

#directory list to traverse
DIRECTORY_LIST=("a" "b" "c" "d" "e" "f")
#todays date
TODAY=`date '+%b %e'`
#we will use this report to email
REPORT_NAME='/tmp/report.txt'


# this is the function that will traverse the directories one by one 
function traverse() {
for directory in ${DIRECTORY_LIST[@]}
do
    if [[ -d ${1}/${directory} ]]; then
        if [ "$(ls -A ${1}/${directory})" ]; then
            cd ${1}/${directory}
            if [ "$(ls -ltr | grep -i "$TODAY")" ]; then
                name=`ls -ltr | grep -i "$TODAY" | awk '{print $9}'`
                # check for corrupted file usinf "tar -xvzf "
                untar_file=`tar -xvzf $name -O`
                if [ $? -eq 0 ]; then
                        echo "file is not corrupted"
                        #find average file size and average time for the last 30 days 
                        average_size=$(find $(pwd) -type f -mtime -30 -ls |  awk '{sum += $7; n++;} END {print sum/n;}')
                        average_time=$(find $(pwd) -type f -mtime -30 -ls | awk '{print  $10}' | awk '{split($0, a, ":"); sum += a[1]; n++;} END {print sum/n;}')
                        today_file_size=$(ls -l | grep -v 'total'| awk '{print $5}')
                        today_file_time=$(ls -l | grep -v 'total'| awk '{print $8}' |awk '{split($0, a, ":"); print a[1]}')
                        size_deviation=$(echo $average_size*0.2| bc)
                        time_deviation=2
                        int_size_deviation=$( printf "%.0f" $size_deviation )
                        max_size=$(($average_size + $int_size_deviation))
                        min_size=$(($average_size - $int_size_deviation))
                        max_time=$(($average_time + $time_deviation))
                        min_time=$(($average_time - $time_deviation))
                        if [[ $today_file_size -ge $max_size ]] || [[ $today_file_size -le $min_size ]]; then
                                echo "Size of file not met defined criteria , $name in directory $directory" >> $REPORT_NAME
                        else
                                echo "do nothing"
                        fi
                        if [[ 10#$today_file_time -ge  $max_time ]] || [[ 10#$today_file_time -le $min_time ]]; then
                                echo "time of file not met defined criteria , $name in directory $directory" >> $REPORT_NAME
                        else
                                echo "do nothing"
                        fi
                else
                        echo "file corrupted :  $name, in directory:  $directory" >> $REPORT_NAME
                fi
            else
"assn.sh" 89L, 3326C                                                                                                                                                                                                        43,7-28       Top
                echo "entered"
                name=`ls -ltr | grep -i "$TODAY" | awk '{print $9}'`
                untar_file=`tar -xvzf $name -O`
                if [ $? -eq 0 ]; then
                        echo "file is not corrupted"
                        #find average file size
                        average_size=$(find $(pwd) -type f -mtime -30 -ls |  awk '{sum += $7; n++;} END {print sum/n;}')
                        average_time=$(find $(pwd) -type f -mtime -30 -ls | awk '{print  $10}' | awk '{split($0, a, ":"); sum += a[1]; n++;} END {print sum/n;}')
                        today_file_size=$(ls -l | grep -v 'total'| awk '{print $5}')
                        today_file_time=$(ls -l | grep -v 'total'| awk '{print $8}' |awk '{split($0, a, ":"); print a[1]}')
                        size_deviation=$(echo $average_size*0.2| bc)
                        time_deviation=2
                        int_size_deviation=$( printf "%.0f" $size_deviation )
                        max_size=$(($average_size + $int_size_deviation))
                        min_size=$(($average_size - $int_size_deviation))
                        max_time=$(($average_time + $time_deviation))
                        min_time=$(($average_time - $time_deviation))
                        if [[ $today_file_size -ge $max_size ]] || [[ $today_file_size -le $min_size ]]; then
                                echo "Size of file not met defined criteria , $name in directory $directory" >> $REPORT_NAME
                        else
                                echo "do nothing"
                        fi
                        if [[ 10#$today_file_time -ge  $max_time ]] || [[ 10#$today_file_time -le $min_time ]]; then
                                echo "time of file not met defined criteria , $name in directory $directory" >> $REPORT_NAME
                        else
                                echo "do nothing"
                        fi
                else
                        echo "file corrupted :  $name, in directory:  $directory" >> $REPORT_NAME
                fi
            else
                echo "no file arrived in $directory" > file.txt
            fi
            cd ../..
        else
            echo "${1}/${directory} is Empty take action" >> $REPORT_NAME
        fi
    else
        echo "found a file with same name , skipping file ${1}/${directory}"
    fi
done
}

function send_mail() {
subject="System logs Status Alert"
##sending mail as
from="server.monitor@example.com"
## sending mail to
to="admin1@example.com"
## send carbon copy to
also_to="admin2@example.com"
## send email
echo "sending email..." | mailx -a "$REPORT_NAME" -s "$subject" -r "$from" -c "$to" "$also_to"
}

function main() {
    traverse "$1"
}

main "$1"
send_mail()