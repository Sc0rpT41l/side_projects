#! /bin/bash

# Making the backup function itself with namegiving process
backup () {
	# Add timestamp to backup filename
	gen_date=$(date '+%d-%m-%Y')
	spec_date=$(date -d "+3 hours" +"%H-%M") # To account for the 3 hours delay on the clock
	backup_filename="${what_to_backup}_${gen_date}_${spec_date}"
	path_to_backup="${where_to_backup}/${backup_filename}"
	# Real copying part
	cp "$what_to_backup" "$path_to_backup"
	echo "Backup succesful!"
}

read -p "What do you want to backup?: " what_to_backup
read -p "Where do you want to back it up?: " where_to_backup

while true; do
	# Check if the file to backup exists
	if [ -e "$what_to_backup" ]; then
		# Check if the backup location exists
		if [ -e "$where_to_backup" ]; then
			backup # See backup function at the top of the script
			ls -all "$where_to_backup"
			break
		else
			echo ""$where_to_backup" doesn't exist"
			while true; do
				read -p "Do you want to create this directory? (y/n): " create_dir_yn
				case "$create_dir_yn" in
					y|Y|yes|Yes|YES)
						mkdir "$where_to_backup"
						echo "Directory succesfully created!"
						echo "Attempting to backup to this location..."
						backup # See backup function at the top of the script
						ls -all "$where_to_backup"
						exit 0
						;;
					n|N|no|No|NO) 
						read -p "Please give a valid place to backup to: " where_to_backup
						break
						;;
					*) 
						read -p "Please give a valid answer. (y/n)"
						;;
				esac
			done
		fi
	else
		echo ""$what_to_backup" doesn't exist"
		read -p "Give a valid thing to backup: " what_to_backup
	fi
done
