#! /bin/bash

# Date to add to log filename
gen_date=$(date +%d-%m-%y)

# Remove FAILED file to avoid confusion
rm $HOME/log/FAILED_${gen_date}.log 2>/dev/null

# Check if last line of dir_checker.log is the same as now to be able to backup the new files too
# Checksum doesn't take new files into account just checks for changes


sha256sum -c $HOME/log/dir_checker_${gen_date}.log 2>/dev/null | grep "FAILED" > $HOME/log/FAILED_${gen_date}.log
find $1 -type f -print0 | xargs -0 -n1 'sha256sum' > /home/kali/log/dir_checker_${gen_date}.log

if [[ -s /home/kali/log/FAILED_${gen_date}.log ]]; then
	echo "Changes were made, file is not empty."
	cat /home/kali/log/FAILED_${gen_date}.log
	if  [[ -d Backup ]]; then
		# Copy changed files to this directory
else
	echo "No changes were made, file is empty."
fi





#v	1) checksum of every file in specified dir
#v	2) put checksum with corresponding filename in temp file
#v	3) compare last checksum of files with newer checksum of file
#	4) make backup of this new version of file and log this in log file with timestamp
#	5) if file doesn't already have a checksum in temp file make a new one and backup this file
