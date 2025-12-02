#! /usr/bin/bash

while true
do
choice=$( zenity --list --title="Table Main menu" --column="Options" "Create Table" "List Tables" "Insert into Table" "Select From Table" "Delete From Table" "Drop Table" "Exit")
if [[ $? -eq 0 ]]
then
case $choice in
"Create Table") 
~/bashDBMS/createtable.sh
;;
"List Tables") 
~/bashDBMS/listtables.sh
;;
 "Insert into Table") 
~/bashDBMS/insertintotable.sh
;;
"Select From Table") 
~/bashDBMS/selectfromtable.sh
;;
"Delete From Table")
~/bashDBMS/deletefromtable.sh
;; 
"Drop Table")
~/bashDBMS/droptable.sh
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
