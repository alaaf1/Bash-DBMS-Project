#! /usr/bin/bash
source ~/bashDBMS/helper.sh
result=$(list_tables)
if [[ $result -eq 0 ]]
then
	zenity --info --text="No Table Found!" 
else
zenity --text-info --title="Tables" --filename="tables.txt"
fi



