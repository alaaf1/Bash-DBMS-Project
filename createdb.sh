#! /usr/bin/bash

dbname=$(zenity --title="create database" --text="Please enter database name: " --entry)
echo "Database name: $dbname"
if (( $? == 0 ))
then
	if [[ -n $dbname ]]
	then
		declare -i exist=0
		for var in $(ls) 
		do
			if [[ "$dbname" == "$var" ]] 
			then
			exist=1
			zenity --error --text="Database already exists"	
			break
			fi
		done
		if (( $exist==0 )) 
		then
			if [[ $dbname =~ ^[^0-9][A-Za-z0-9]+$ ]] 
			then
			mkdir ./$dbname
			zenity --info --text="Database created successfully"
			else
			zenity --error --text="Database name is invalid"	
			fi
		fi
			
			
	else
	zenity --error --text="Database name is empty "
	fi 				
 			
fi
