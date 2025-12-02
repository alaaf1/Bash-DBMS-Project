#! /usr/bin/bash
source ./helper.sh
result=$(list_dbs)
if [[ $result -eq 0 ]]
then
	zenity --info --text="No Database Found!" 
else
	choice=$(zenity --list --title="Drop database" --column="Databases" $(cat databases.txt))
	if(($? == 0))
	then
		if [[ -n $choice ]]
		then
		zenity  --question --text="Are you sure you want to delete $choice database?"
			if(($? == 0))
			then
			rm -r $choice
			zenity --info --text="Databased deleted successfully"
			else 
			zenity --info --text="No Action Taken"
			fi
		else
		zenity --info --text="No Database chosen"
	fi
	fi
fi
