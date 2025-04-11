#! /bin/bash



if [[ $(id -u) -eq 0 ]] ; then
	echo "You're logged in as root"
else
	echo "You're not logged in as root"
fi
