#! /bin/bash

#Function for getting date
get_date () {
	gen_date=$(date '+%d-%m-%Y')
	spec_date=$(date -d "+3 hours" +"%H-%M") # To account for the 3 hours delay on the clock
}

# Making the backup function for files/directories with namegiving process
backup_file_dir () {
        # Add timestamp to backup filename
        get_date
        f_d_backup_name="${f_d_to_backup}_${gen_date}_${spec_date}"
        f_d_path_to_backup="${f_d_where_to_backup}/${f_d_backup_name}"
        # Real copying part
        cp -r "$f_d_to_backup" "$f_d_path_to_backup"
        echo "Backup successful!"
}


# Making the backup function for databases with namegiving process
backup_db () {
	# Add timestamp to backup database
        get_date
        db_backup_name="${db_to_backup}_${gen_date}_${spec_date}"
        db_path_to_backup="${db_where_to_backup}/${db_backup_name}"
        # Real backup process
	sudo mysqldump -u root -p"$db_password" "$db_to_backup" --databases >> "${db_path_to_backup}.sql"
        echo "Backup successful!"
}

# Check if file is run with sudo permissions
if [[ $(id -u) -eq 0 ]]; then
	:
elif [[ $(id -u) -ne 0 ]]; then
	echo "Root privileges are necessary, please login as root."
	exit 0
else
	echo "Something went wrong while checking privileges."
	exit 0
fi

# Start the mysql service
echo "Mysql service starting..."
sudo service mysql start
echo "Mysql service started successfully"

while true; do

	read -p "Do you want to save a file/directory or a database?" kind_to_backup
	case "$kind_to_backup" in
		file|FILE|File|directory|dir|Directory|DIRECTORY|DIR)

			read -p "What file/directory do you want to backup?: " f_d_to_backup
			read -p "Where do you want to back it up?: " f_d_where_to_backup
			# echo "${f_d_to_backup} and ${f_d_where_to_backup}" this line was just to check
			while true; do
				# Check if the file to backup exists
				if [ -e "$f_d_to_backup" ]; then
					# Check if the backup location exists
					if [ -e "$f_d_where_to_backup" ]; then
						backup_file_dir
						ls -all "$f_d_where_to_backup"
						break
					else
						echo "${f_d_where_to_backup} doesn't exist"
						while true; do
							read -p "Do you want to create this directory? (y/n): " f_d_create_dir_yn
							case "$f_d_create_dir_yn" in
								y|Y|yes|Yes|YES)
									mkdir "$f_d_where_to_backup"
									echo "Directory successfully created!"
									echo "Attempting to backup to this location..."
									backup_file_dir
									ls -all "$f_d_where_to_backup"
									exit 0
									;;

								n|N|no|No|NO)
									read -p "Please give a valid place to backup to: " f_d_where_to_backup
									break
									;;

								*)
									read -p "Please give a valid answer. (y/n)" f_d_create_dir_yn
									;;
							esac
						done
					fi
				else
					echo "${f_d_to_backup} doesn't exist"
					read -p "Give a valid file or directory to backup: " f_d_to_backup
				fi
			done
		exit 0
		;;
		#########################################################################################################
		#########################################################################################################
		database|Database|DATABASE|db|DB|Db|dB)
			read -sp "Enter your password to login to your databases." db_password
			echo
			sudo mysql -u root -p"$db_password" -e "SHOW DATABASES;"
			read -p "What database do you want to backup?: " db_to_backup
	        	read -p "Where do you want to back it up?: " db_where_to_backup
			# echo "${db_to_backup} and ${db_where_to_backup}" This line was just to check

			while true; do
		                if sudo mysql -u root -p"$db_password" -e "SHOW DATABASES;" | tail -n +2 | grep -Fxq "$db_to_backup"; then
		                	# Check if the backup location exists
		                        if [ -e "$db_where_to_backup" ]; then
		                        	backup_db
		                                ls -all "$db_where_to_backup"
		                                echo "Backup successful!"
						exit 0
		                        else
		                        	echo "${db_where_to_backup} doesn't exist"
		                                while true; do
		                                	read -p "Do you want to create this directory? (y/n): " db_create_dir_yn
		                                        case "$db_create_dir_yn" in
	        	                                	y|Y|yes|Yes|YES)
	        	                                        	mkdir "$db_where_to_backup"
	               		                                        echo "Directory successfully created!"
	                      		                                echo "Attempting to backup to this location..."
									backup_db
	                                                        	ls -all "$db_where_to_backup"
	                                                        	exit 0
	                                                        	;;

		                                                n|N|no|No|NO)
		                                                        read -p "Please give a valid place to backup to: " db_where_to_backup
		                                                        break
		                                                        ;;

		                                                *)
					                               	read -p "Please give a valid answer. (y/n) " db_create_dir_yn
		                                                        ;;

		                                        esac
		                                done
		                        fi
		                else
		                                echo "${db_to_backup} doesn't exist"
		                                read -p "Give a valid thing to backup: " db_to_backup
		                fi
		        done
		exit 0
		;;
		#########################################################################################################
		#########################################################################################################
		*)
			read -p "Please give a valid answer. (y/n) " kind_to_backup
		;;
	esac
done
