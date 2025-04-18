#! /bin/bash
## WATCHER ##
#########################ARGUMENTS#########################
# $1 => directory-to-check, please give full path
# $2 => name for new backup folder, please give full path
###########################################################

###########################TO DO###########################
# ////1) Checksum doesn't take new files into account just checks for changes
# ////2) Make sure that the dir structure is kept!!!
# ////2) Copy changed files to this directory
# ////3) Show the changes made in changed.log (like git does)
# 4) Put this script inside cronjobs for every 5 minutes or something like that
# ////5) Make it so that there will always be a backup dir to backup to by putting numbers behind backup dir name
# ////6) Finalise by zipping the whole backup, less often than running this script (every 12.00h and 00.00h => cronjob should be run at this instant
# ////7) Make second given argument name for backup dir
# ////8) Make it so that FAILED log is cleared after old files have been renewed
# 9) Make all /home/kali/ ... user input dependable!!!!
# 10) Make often-used paths into variables
# 11) Make sure script doesn't flip when deleted files can´t be backupped anymore
###########################################################

#--------------------------
# Paths put into variables
#--------------------------
# Snapshot folder names
SNAPSHOT="${HOME}/log/.snapshot"
current=$(mktemp)

# Do some operations to get last dir of full path of $1
last_part_dir_check1=$(echo ${1} | rev | cut -d "/" -f 1 | rev)

# Do some more operations to get last dir of full path of $2
last_part_dir_check2=$(echo ${2} | rev | cut -d "/" -f 1 | rev)

# Timestamp for log with changes made and to add to log filename
gen_date=$(TZ=Europe/Paris date '+%d-%m-%Y') # Day, month and year
spec_date=$(TZ=Europe/Paris date '+%H-%M') # Hours and minutes

###########################################################

#-------------------
# First time backup
#-------------------

# Copy all files to the backup directory if it´s empty wich means it´s the first time
if [[ -d $2 && -z "$(ls -A $2)" ]]; then # Dir exists and empty
	cp -r $1 $2
elif [[ ! -d $2 ]]; then # Dir not exist and empty
	mkdir $2
	cp -r $1 $2
else # Dir exists and NOT empty => NOT first time
	:
fi

###########################################################

#-------------------------
# Add new files to backup
#-------------------------

# Makes a snapshot with current files if it doesn't exist already (first time)
if [[ ! -f "$SNAPSHOT" ]]; then
	find $1 -type f | sort > "$SNAPSHOT"
	echo "snapshot created"
fi

# Get current file list and store it in temp file
find $1 -type f | sort > "$current"

# Compare and show newly added files
comm -13 "$SNAPSHOT" "$current" > $HOME/log/.new_files.txt
if [[ -s $HOME/log/.new_files.txt ]]; then
	echo "New files detected"
	cat $HOME/log/.new_files.txt
	# Put new files inside backup folder
	while IFS= read -r newfile; do
		cp "$newfile" 
	done < $HOME/log/.new_files.txt

	# Empty the .new_files.txt file
	echo > $HOME/log/.new_files.txt

else
	echo "No new files detected"
fi

# Update snapshot
mv "$current" "$SNAPSHOT"

###########################################################

#-------------------
# Clean FAILED file
#-------------------

# Remove FAILED file to avoid confusion (test phase)
rm $HOME/log/FAILED_${gen_date}.log 2>/dev/null

###########################################################

#-----------------------------------
# Use checksum to check for changes
#-----------------------------------

sha256sum -c $HOME/log/dir_checker_${gen_date}.log 2>/dev/null | grep "FAILED" > $HOME/log/FAILED_${gen_date}.log
find $1 -type f -print0 | xargs -0 -n1 'sha256sum' > /home/kali/log/dir_checker_${gen_date}.log

if [[ -s /home/kali/log/FAILED_${gen_date}.log ]]; then
	echo "Changes were made, FAILED is not empty."

	# Compare old file to new file and diff them into changes.log
	echo "===== [ Timestamp: $(date '+%Y-%m-%d %H-%M-%S') ]=====" >> $HOME/log/changes.log
	echo >> $HOME/log/changes.log
	echo
	echo "This is with improvements"

	while IFS= read -r rel_path; do
		echo "This is rel_path"
		echo ${rel_path}
		echo "$2/${last_part_dir_check1}${rel_path}" " >> " "${1}${rel_path}" >> $HOME/log/changes.log
		diff --color=always "$2/${last_part_dir_check1}${rel_path}" "${1}${rel_path}" >> $HOME/log/changes.log
		echo >> $HOME/log/changes.log
		cp "${1}${rel_path}" "$2/${last_part_dir_check1}${rel_path}"
	done < <(awk -F"${1}" '{print $2}' /home/kali/log/FAILED_${gen_date}.log | cut -d ":" -f 1)

	echo >> $HOME/log/changes.log
	echo "-----------------------------------------------------" >> $HOME/log/changes.log
	echo >> $HOME/log/changes.log

else
	echo "No changes were made, FAILED is empty."
fi

###########################################################

#------------------------
# Put backup in zip file
#------------------------

# if date is 12 hours or 24 hours then zip whole backup folder into zip folder
# and delete last zip folder
if [[ ! -d $HOME/.zip ]]; then
	mkdir $HOME/.zip
else
	:
fi

if [[ "$spec_date" == "00-00" ]]; then
	echo "bedtime!"
	zip -r -q $HOME/.zip/${last_part_dir_check2}_${gen_date}_${spec_date}.zip ${2} $HOME/log
	if [[ $? -eq 0 && $(ls -A ${HOME}/.zip | wc -l) > 1 ]]; then
		rm "$(ls -At $HOME/.zip | tail -n 1 | sed "s|^|${HOME}/.zip/|")"
		exit 0
	fi
elif [[ "$spec_date" == "12-00" ]]; then
	echo "wakey wakey!"
	zip -r -q $HOME/.zip/${last_part_dir_check2}_${gen_date}_${spec_date}.zip ${2} $HOME/log
	if [[ $? -eq 0 && $(ls -A ${HOME}/.zip | wc -l) > 1 ]]; then
		rm "$(ls -At $HOME/.zip | tail -n 1 | sed "s|^|${HOME}/.zip/|")"
		exit 0
	fi
else
	:
fi
