#!/bin/bash

source ~/Bash-DBMS-Project/helper.sh
result=$(list_tables)

if [[ $result -eq 0 ]];
then
	zenity --info --text="No Table Found"
	exit 0
fi

table=$(zenity --list --title="Tables To Choose From:" --column="Tables" $(cat tables.txt))
if [ $? -ne 0 ] || [[ -z "$table" ]]
then
	zenity --info --text="please select a table"
	exit 0
fi

table="${table}"
data_file="${table}.data"
meta_file="${table}.meta"

if [ ! -f "$meta_file" ];
then
	zenity --error --text="Meta File Not found"
	exit 1
fi

columns=$(sed -n '1p' "$meta_file")
data_types=$(sed -n '2p' "$meta_file")
primaryK=$(sed -n '3p' "$meta_file")
columns_separtated=$(echo "$columns" | tr '|' ' ')
choice=$(zenity --list --title="Columns to choose from" --column="Column" $columns_seperated)
if [ $? -ne 0 ] 
then
zenity --error --text="NO Columns found in MetaData"
exit 1 
fi

if [[ -z "$choice" ]]
then
	zenity --error --text="No Column Choosed"
	exit 0
fi
column_no=$(echo "$columns" | tr '|' '\n' | grep -n "^$choice$" | cut -d: -f1)
column_data_type=$(echo "$data_types" | cut -d'|' -f"$column_no")
rows=$(awk -F '|' -v col="$column_no" '{
print NR " - " $col}' "$data_file")

row=$(zenity --list --title="Available Rows to chooses from" 
--text="Rows in the table named: $table (Column: $choice)"
--column="Row Number - Value" $rows)

if [ $? -ne 0 ] || [ -z "$row" ]
then
	exit 0
fi
row_no=$(echo "$row" | cut -d' ' -f1)
updated_value=$(zenity --entry --title="updating" --text="Enter new Value")
if [[ -z "$updated_value" ]]
then
	zenity --error --text="value should not be empty"
	exit 0
elif [[ "$col_data_type" == "int" ]] 
then
	if [[ ! "$updated_value" =~ ^[0-9]+$ ]]
	then
		zenity --error --text="invalid input, expected and int"
		exit 0
	fi

# primary_key_validation


awk -F '|' -v col="$column_no" -v val="$updated_value" -v row="$row_no"'BEGIN { OFS="|"} NR == row { $col = val } { print }' "$data_file" > tmp && mv tmp "$data_file"
zenity --info --text="value updated succesfully"


