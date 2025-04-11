#! /bin/bash

read -p "Do you want to save a file/directory or a database?" kind_to_backup

case "$kind_to_backup" in
	file|FILE|File|directory|dir|Directory|DIRECTORY|DIR)

		read -p "What file/directory do you want to backup?: " what_to_backup
		read -p "Where do you want to back it up?: " where_to_backup

		echo ""$what_to_backup" and "$where_to_backup""

		while true; do
			# Check if the file to backup exists
			if [ -e "$what_to_backup" ]; then
				# Check if the backup location exists
				if [ -e "$where_to_backup" ]; then
					# Add timestamp to backup filename
					gen_date=$(date '+%d-%m-%Y')
					spec_date=$(date -d "+3 hours" +"%H-%M") # To account for the 3 hours delay on the clock
					backup_filename="${what_to_backup}_${gen_date}_${spec_date}"
					path_to_backup="${where_to_backup}/${backup_filename}"
					# Real copying part
					cp "$what_to_backup" "$path_to_backup"
					echo "Backup succesful!"
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
								# Add timestamp to backup filename
								gen_date=$(date '+%d-%m-%Y')
								spec_date=$(date -d "+3 hours" +"%H-%M") # To account for the 3 hours delay>
								backup_filename="${what_to_backup}_${gen_date}_${spec_date}"
								path_to_backup="${where_to_backup}/${backup_filename}"
								#Real copying part
								cp "$what_to_backup" "$path_to_backup"
								echo "Backup succesful!"
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

	database|Database|DATABASE|db|DB|Db|dB)

	jfkljdsklfjdqs
	fjksdlfjdq
	dfjkqlsmdfjk
	sjfdklqdf


	*)

	kdfljfkldfs
	jkdlqjfdkl
	jkldmfjklsf
	kjljdkfl
