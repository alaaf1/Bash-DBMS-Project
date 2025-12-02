#! /usr/bin/bash

while true
do
choice=$( zenity --list --title="Main menu" --column="Options" "Create database" "List databases" "Connect to database" "Drop Database" "Exit")
if [[ $? -eq 0 ]]
then
case $choice in
"Create database") 
./createdb.sh
;;
"List databases") 
./listdb.sh
;;
"Connect to database") 
./connecttodb.sh
;;
"Drop Database") 
./dropdb.sh
;;
"Exit") 
break 
;;
*)
zenity --info --text="please choose option"
esac

elif [[ $? -eq 1 ]]
then
exit 0
else
exit 1
fi
done
