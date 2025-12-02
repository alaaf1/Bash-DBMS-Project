#! /usr/bin/bash
source ./helper.sh
result=$(list_dbs)
if [[ $result -eq 0 ]]
then
	zenity --info --text="No Database Found!" 
else
choice=$( zenity --list --title="Connect to database" --column="Databases" $(cat databases.txt))
if (($?==0))
then
if [[ -n $choice ]]
then
	cd $choice
	zenity --info --text="Connected to $choice successfully"
	../tablemenu.sh 
else
	zenity --info --text="No Database chosen"
fi
fi
fi
