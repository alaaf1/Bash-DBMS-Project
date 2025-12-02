#! /usr/bin/bash
source ~/bashDBMS/helper.sh

colnames=()
coltypes=()
pk=0
rowinput=()
result=$(list_tables)
if [[ $result -eq 0 ]]
then
	zenity --info --text="No Table Found!" 
else
choice=$(zenity --list --title="Tables" --column="Tables" $(cat "tables.txt"))
tablemeta="$choice.meta"
tabledata="$choice.data"
if [[ $? -eq 0 && -n $tablemeta ]]
then
IFS='|' read -a colnames<<<$(sed -n '1p' "$choice.meta")
IFS='|' read -a coltypes<<<$(sed -n '2p' "$choice.meta")
IFS='|' read -a pk <<< $(sed -n '3p' "$choice.meta")
declare -i pkindex=$(findPK_index "$choice")
declare -i i=0
for i in ${!colnames[@]} 
do
col=${colnames[$i]}
if(( $pkindex == $i ))
then
  while true
  do
  colvalue=$(zenity --entry --title="Insert" --text="Please insert value for PK: $col")
  if [[ $? -eq 0 && -n $colvalue ]]
     then
     valid=$(validate_input $i $colvalue $choice)
     if [[ $valid == true ]]
     then
     	declare -i pk=$pkindex+1
     	if awk -F' ' -v val="$colvalue" -v colindex="$pk" 'NR>1 {if($colindex==val) exit 1 }' $tabledata
     	then
        	rowinput+=("$colvalue")
        	break
        	else
        	zenity --error --text="Duplicate input"
        	fi
     else
        zenity --error --text="Please Enter valid input"
     fi
  else
     zenity --error --text="must Enter input for primary key"
  fi
  done
else
	colvalue=$(zenity --entry --title="Insert" --text="Please insert value for: $col")
	if [[ $? -eq 0 && -n $colvalue ]]
	then
		valid=$(validate_input $i $colvalue $choice)
		if [[ $valid == true ]]
		then
		rowinput+=("$colvalue")
		else
		zenity --error --text="Invalid input"
		fi
	else
		rowinput+=("null")
	fi
fi
done
fi
fi


printf "%s|" "${rowinput[@]}">>$tabledata
sed -i '$ s/|$//' $tabledata
echo "">>$tabledata

