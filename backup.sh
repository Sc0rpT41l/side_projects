#! /bin/bash

# Making the backup function for files/directories with namegiving process
backup_file_dir () {
        # Add timestamp to backup filename
        gen_date=$(date '+%d-%m-%Y')
        spec_date=$(date -d "+3 hours" +"%H-%M") # To account for the 3 hours delay on the clock
        backup_filename="${f_d_to_backup}_${gen_date}_${spec_date}"
        path_to_backup="${where_to_backup}/${backup_filename}"
        # Real copying part
        cp "$f_d_to_backup" "$path_to_backup"
        echo "Backup succesful!"
}


# Making the backup function for databases with namegiving process
backup_db () {
	# Add timestamp to backup database
        gen_date=$(date '+%d-%m-%Y')
        spec_date=$(date -d "+3 hours" +"%H-%M") # To account for the 3 hours delay on the clock
        backup_db_name="${f_d_to_backup}_${gen_date}_${spec_date}"
        path_to_backup="${where_to_backup}/${backup_db_name}"
        # Real backup process
	dumpmysql
        echo "Backup succesful!"


}


read -p "Do you want to save a file/directory or a database?" kind_to_backup

case "$kind_to_backup" in
	file|FILE|File|directory|dir|Directory|DIRECTORY|DIR)

		read -p "What file/directory do you want to backup?: " f_d_to_backup
		read -p "Where do you want to back it up?: " where_to_backup

		echo ""$f_d_to_backup" and "$where_to_backup""

		while true; do
			# Check if the file to backup exists
			if [ -e "$f_d_to_backup" ]; then
				# Check if the backup location exists
				if [ -e "$where_to_backup" ]; then
					backup_file_dir
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
								backup_file_dir
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
				echo ""$f_d_to_backup" doesn't exist"
				read -p "Give a valid thing to backup: " f_d_to_backup
			fi
		done
	;;

	database|Database|DATABASE|db|DB|Db|dB)

	
	fjksdlfjdq
	dfjkqlsmdfjk
	sjfdklqdf


	*)

	kdfljfkldfs
	jkdlqjfdkl
	jkldmfjklsf
	kjljdkfl
