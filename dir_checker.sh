#! /bin/bash

# Run this every minute or so

# Date to add to log filename
gen_date=$(date +%d-%m-%y)

find $1 -type f -print0 | xargs -0 -n1 'sha256sum' > /var/log/dir_checker_${gen_date}.log
sha256sum -c /var/log/dir_checker_${gen_date}.log | grep "FAILED" > /var/log/FAILED_${gen_date}.log

if [ -s /var/log/FAILED_${gen_date}.log ]; 
	echo "No changes made"
	exit 0
else


fi








#v	1) checksum of every file in specified dir
#v	2) put checksum with corresponding filename in temp file
#	3) compare last checksum of files with newer checksum of file
#	4) make backup of this new version of file and log this in log file with timestamp
#	5) if file doesn't already have a checksum in temp file make a new one and backup this file
