#! /usr/bin/bash
source ./helper.sh
result=$(list_dbs)
if [[ $result -eq 0 ]]
then
	zenity --info --text="No Database Found!" 
else
zenity --text-info --title="Databases" --filename="databases.txt"
fi



