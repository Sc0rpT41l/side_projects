#! /bin/bash

#########################ARGUMENTS#########################
# $1 => directory to check
# $2 => name for new backup folder, please give full path
##########################################################

###########################TO DO###########################
# ////1) Checksum doesn't take new files into account just checks for changes
# 2) Make sure that the dir structure is kept!!!
# 2) Copy changed files to this directory
# 3) Show the changes made in changed.log (like git does)
# 4) Put this script inside cronjobs for every 5 minutes or something like that
# 5) Make it so that there will always be a backup dir to backup to by putting numbers behind backup dir name
# 6) Finalise by zipping the whole backup
# 7) Make second given argument name for backup dir
###########################################################

# Timestamp for log with changes made and to add to log filename
gen_date=$(date '+%d-%m-%Y')
spec_date=$(date -d "+3 hours" +"%H-%M") # To account for the 3 hours delay on the clock


# Copy all files to the backup directory if it´s empty wich means it´s the first time
if [[ -d $2 && -z "$(ls -A $2)" ]]; then # Dir exists and empty
	cp -r $1 $2
elif [[ ! -d $2 ]]; then # Dir not exist and empty
	mkdir $2
	cp -r $1 $2
else # Dir exists and NOT empty => NOT first time
	:
fi

# Remove FAILED file to avoid confusion
rm $HOME/log/FAILED_${gen_date}.log 2>/dev/null

sha256sum -c $HOME/log/dir_checker_${gen_date}.log 2>/dev/null | grep "FAILED" > $HOME/log/FAILED_${gen_date}.log
find $1 -type f -print0 | xargs -0 -n1 'sha256sum' > /home/kali/log/dir_checker_${gen_date}.log

if [[ -s /home/kali/log/FAILED_${gen_date}.log ]]; then
	echo "Changes were made, FAILED is not empty."
	cat /home/kali/log/FAILED_${gen_date}.log
	# 2) &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
else
	echo "No changes were made, FAILED is empty."
fi





#v	1) checksum of every file in specified dir
#v	2) put checksum with corresponding filename in temp file
#v	3) compare last checksum of files with newer checksum of file
#	4) make backup of this new version of file and log this in log file with timestamp
#	5) if file doesn't already have a checksum in temp file make a new one and backup this file
