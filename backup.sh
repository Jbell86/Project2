#!/usr/bin/bash

# This bash script is used to back up a user's home directory to /tmp/.

function backup {
# The purpose of this if-else block is to take a single argument and if that argument is left blank then it uses whoami to load the current user's name.
# If the user's name is already provided then it goes to the home of that user.
if [ -z $1 ]; then
	user=$(whoami)
else
	if [ ! -d "/home/$1" ]; then
		echo "Requested $1 user home directory doesn't exist."
		exit 1
	fi
	user=$1
fi

input=/home/$user
output=/tmp/${user}_home_$(date +%Y-%m-%d_%H%M%S).tar.gz

# The function total_files reports a total number of files for a given directory.

function total_files {
	find $1 -type f | wc -l
}

# the function total_directories reports a total number of directories
# for a given directory.

function total_directories {
	find $1 -type d | wc -l
}

function total_archived_directories {
tar -tzf $1 | grep /$ | wc -l
}

function total_archived_files {
tar -tzf $1 | grep -v /$ | wc -l
}

tar -czf $output $input 2> /dev/null

src_files=$( total_files $input )
src_directories=$( total_directories $input )

arch_files=$( total_archived_files $output )
arch_directories=$( total_archived_directories $output )

echo "########## $user ##########"
echo "Files to be included: $src_files"
echo "Directories to be included: $src_directories"
echo "Files archived: $arch_files"
echo "Directories archived: $arch_directories"
# The purpose of this if-else block is to give the user information on the status of the backup.
if [ $src_files -eq $arch_files ]; then
echo "Backup of $input completed!"
echo "Details about the backup file:"
ls -l $output

else
	echo "Backup of $input failed!"
fi
}
# This for block is used to backup the directory.
for directory in $*; do
	backup $directory
done;


