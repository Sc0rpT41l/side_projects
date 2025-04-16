#! /bin/bash

#########################ARGUMENTS#########################
# $1 => directory-to-check, please give full path
# $2 => name for new backup folder, please give full path
##########################################################

###########################TO DO###########################
# ////1) Checksum doesn't take new files into account just checks for changes
# ////2) Make sure that the dir structure is kept!!!
# ////2) Copy changed files to this directory
# ////3) Show the changes made in changed.log (like git does)
# 4) Put this script inside cronjobs for every 5 minutes or something like that
# ////5) Make it so that there will always be a backup dir to backup to by putting numbers behind backup dir name
# 6) Finalise by zipping the whole backup, less often than running this script (every 12.00h and 00.00h => cronjob should be run at this instant
# ////7) Make second given argument name for backup dir
# ////8) Make it so that FAILED log is cleared after old files have been renewed
# 9) Make all /home/kali/ ... user input dependable!!!!
###########################################################

# Do some operations to get last dir of full path of $1
last_part_dir_check=$(echo ${1} | rev | cut -d "/" -f 1 | rev)

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

# Remove FAILED file to avoid confusion (test phase)
rm $HOME/log/FAILED_${gen_date}.log 2>/dev/null

sha256sum -c $HOME/log/dir_checker_${gen_date}.log 2>/dev/null | grep "FAILED" > $HOME/log/FAILED_${gen_date}.log
find $1 -type f -print0 | xargs -0 -n1 'sha256sum' > /home/kali/log/dir_checker_${gen_date}.log

if [[ -s /home/kali/log/FAILED_${gen_date}.log ]]; then
	echo "Changes were made, FAILED is not empty."

	# Compare old file to new file and diff them into changes.log
	echo "===== [ Timestamp: $(date '+%Y-%m-%d %H:%M:%S') ]=====" >> $HOME/log/changes.log
	echo >> $HOME/log/changes.log
	echo
	echo "This is with improvements"
##########
	while IFS= read -r rel_path; do
		echo "This is rel_path"
		echo ${rel_path}
		echo "$2/${last_part_dir_check}${rel_path} ${1}${rel_path}" # First part is full_rel_path
		diff --color=always "$2/${last_part_dir_check}${rel_path}" "${1}${rel_path}" >> $HOME/log/changes.log
		cp "${1}${rel_path}" "$2/${last_part_dir_check}${rel_path}"
	done < <(awk -F"${1}" '{print $2}' /home/kali/log/FAILED_${gen_date}.log | cut -d ":" -f 1)
##########
	echo
	echo >> $HOME/log/changes.log
	echo "-----------------------------------------------------" >> $HOME/log/changes.log
	echo >> $HOME/log/changes.log

else
	echo "No changes were made, FAILED is empty."
fi






if date is 12 hours or 24 hours then zip whole backup folder into zip folder
and delete zip folder with date - 4 hours 
