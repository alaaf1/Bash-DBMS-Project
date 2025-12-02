#!/bin/bash

source ~/Bash-DBMS-Project/helper.sh
result=$(list_tables)

delete_by_id() {
	table="$1"
	id=$(zenity --entry --title="Deleted by ID" --text="Enter ID to delete:")
if [[ -z "$id" ]];
then 
	zenity --error --text="ID connot by empty"
	return

elif ! [[ "$id" =~ ^[0-9]+$ ]];
then
	zenity --error --text="ID should be int"
	return

elif ! grep -q "^$id:" "$data_file";
then
	zenity --error --text="id doesnt exist in the table"
	return
fi
grep -v "^$id:" "$data_file" > tmp && mv tmp "$data_file"
zenity --info --text="row with id $id was deleted successfully"

}

delete_by_column() {
table="$1"
columns=$(head n 1 "$meta_file" | tr '|' ' ')
choice=$(zenity --list --title ="columns to choose from:" --column="Column" $columns)

if [[ -z "$choice" ]];
then
	zenity --error --text="you have to select a column"
	return;
fi
get_column=$(grep -n "^$choice$" "$meta_file" | cut -d: -f1)
value_to_delete=$(zenity --entry --title="deleting" --text="Enter value to delete")
if [[ -z "$value_to_delete" ]]
then 
	zenity --error --text="value should not be empty"
	return
fi
if ! awk -F":" -v col="$get_column" -v val="$value_to_delete" '$col == val {found=1} END {exit !found}' "$data_file"
then
zenity --error --text="not found"
return
fi
	awk -F":" -v col="$get_column" -v val="$value_to_delete" '$col != val' "$data_file" > tmp && mv tmp "$data_file"
zenity --info --text="rows deleted successfully"

}

delete_all() {
	table="$1"

if zenity --question --text="you sure you want to delete all records in '$data_file'?"
then
#head -n 1 "$data_file" >tmp && mv tmp
> "$data_file"
zenity --info --text="All records were deleted successfully except column names"
fi
}

if [[ $result -eq 0 ]];
then 
	zenity --info --text="No Table Found!"
	exit 0
fi
table=$(zenity --list --title="which table to delete from" --column="Tables" $(cat tables.txt))
if [[ -z "$table" ]] 
then
	zenity --error --text="please select a table"
fi

table="${table}"
data_file="${table}.data"
meta_file="${table}.meta"

	choice=$(zenity --list --title="Delete from Table" --column="Options" "Delete by ID" "Delete by Column" "Delete All Records")
	
	case "$choice" in 
		"Delete by ID") 
#			id=$(zenity --entry --text="Enter ID to delete:")
			delete_by_id "$table" "$id"
		#	zenity --info --text-"Row Deleted successfully"
			;;
		"Delete by Column")
			delete_by_column "$table"
		#	zenity --info --text="Row Deleted successfully"
			;;
		"Delete All Records")
			delete_all "$table"
		#	zenity --info --text="Records deleted successfully"
			;;
		*)
			zenity --info --text="No Action Taken"
			;;
	esac



