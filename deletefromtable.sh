#!/bin/bash

source ~/Bash-DBMS-Project/helper.sh
result=$(list_tables)

delete_by_id() {
	table="$1"
	id=($zenity --entry --title="Deleted by ID" --text="Enter ID to delete:")
if [[ -z "$id" ]];
then 
	zenity --error --text="ID connot by empty"
	return

elif ! [[ "$id" =~ ^[0-9]+$ ]];
then
	zenity --error --text="ID should be int"
	return

elif ! grep -q "^$id:" "$table";
then
	zenity --error --text="id doesnt exist in the table"
	return
fi
grep -v "^$id:" "$table" > tmp && tmp "$table"

}

delete_by_column() {
table="$1"
columns=$(cut -d: -f1 "$table.meta")
choice=$(zenity --list --title ="columns to choose from:" --column="Column" $columns)

if [[ -z "$choice" ]];
then
	zenity -error --text="value should not be empty"
	return;
fi
get_column=$(grep -n "^$choice$" "$table.meta" | cut -d: -f1)
value_to_delete=$(zenity --entry --title="deleting" --text="Enter value to delete")
if [[ -z "$get_column" ]];
then
       	zenity --error --text="column field canot be empty"
	return;
fi
if [[ -z "$value_to_delete" ]]
then 
	zenity --error --text="value should not be empty"
	return
fi
#if [[ !awk -F":" -v col="$get_column" -v val="$value_to_delete" '$col == val {found=1} END {exit !found}' "$table" ]]
#then
#zenity --errror --text="not found"
#return
#fi
	awk -F":" -v column="$get_column" -v value="$value_to_delete" '$column != value' "$table" > tmp && mv tmp "$table"


}


if [[$result -eq 0 ]];
then 
	zenity --info --text="No Table Found!"
else
	choice=$(zenity --list --title="Delete from Table" --column="Options" "Delete by ID" "Delete by Column")
	
	case "$choice" in 
		"Delete by ID") 
			id=$(zenity --entry --text="Enter ID to delete:")
			delete_by_id "$table" "$id"
			zenity -info --text-"Row Deleted successfully"
			;;
		"Delete by Column")
			delete_by_column "$table"
			zenity --info --text="Row Deleted successfully"
			;;
		*)
			zenity --info --text="No Action Taken"
			;;
	esac
fi


