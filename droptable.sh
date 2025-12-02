#! /usr/bin/bash
source ~/bashDBMS/helper.sh
result=$(list_tables)
if [[ $result -eq 0 ]]
then
	zenity --info --text="No Table Found!" 
else
	choice=$(zenity --list --title="Drop Table" --column="Tables" $(cat tables.txt))
	if(($? == 0))
	then
		if [[ -n $choice ]]
		then
		zenity  --question --text="Are you sure you want to drop the table $choice?"
			if(($? == 0))
			then
			rm -f $choice
			#rm -f "$choice.meta"
			zenity --info --text="Table deleted successfully"
			else 
			zenity --info --text="No Action Taken"
			fi
		else
		zenity --info --text="No Table chosen"
	fi
	fi
fi
